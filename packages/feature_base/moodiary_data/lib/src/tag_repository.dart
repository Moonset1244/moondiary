import 'dart:async';

import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';
import 'package:moodiary_models/moodiary_models.dart';

import 'db/database.dart';
import 'db/db_codec.dart';

/// 多级标签仓储（自记）。tags 是注册表（层级+颜色）；
/// diary_tags 仍按名字关联，重命名在事务内同步更新，保证旧备份可恢复。
@lazySingleton
class TagRepository {
  TagRepository(this._db);

  final MoodiaryDatabase _db;

  final StreamController<TagEvent> _events = StreamController<TagEvent>.broadcast();

  Stream<TagEvent> get tagEvents => _events.stream;

  static Tag _toTag(TagRow r) => Tag(
    id: r.id,
    name: r.name,
    lastModified: dbToTime(r.lastModified),
    parentId: r.parentId,
    color: r.color,
  );

  static TagsCompanion _toCompanion(Tag t) =>
      TagsCompanion.insert(
        id: t.id,
        name: t.name,
        lastModified: dbTime(t.lastModified),
        parentId: Value(t.parentId),
        color: Value(t.color),
      );

  Future<List<Tag>> getAllTags() async {
    final rows = await (_db.select(
      _db.tags,
    )..orderBy([(t) => OrderingTerm.asc(t.name)])).get();
    return [for (final r in rows) _toTag(r)];
  }

  Future<Tag?> getTagById(String id) async {
    final row = await (_db.select(
      _db.tags,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
    return row == null ? null : _toTag(row);
  }

  Future<Tag?> getTagByName(String name) async {
    final row = await (_db.select(
      _db.tags,
    )..where((t) => t.name.equals(name))).getSingleOrNull();
    return row == null ? null : _toTag(row);
  }

  Future<void> insertATag(Tag tag, {bool fromSync = false}) async {
    await _db.transaction(() async {
      await _db.into(_db.tags).insertOnConflictUpdate(_toCompanion(tag));
      await (_db.delete(
        _db.tombstones,
      )..where((t) => t.key.equals(SyncTombstone.tagKey(tag.id)))).go();
    });
    _events.add(TagUpserted(tag, fromSync: fromSync));
  }

  /// 重命名：tags 与 diary_tags 的名字键在事务内一起更新。
  Future<bool> renameTag(String id, String newName) async {
    final updated = await _db.transaction(() async {
      final row = await (_db.select(
        _db.tags,
      )..where((t) => t.id.equals(id))).getSingleOrNull();
      if (row == null || row.name == newName) return false;
      final clash = await (_db.select(
        _db.tags,
      )..where((t) => t.name.equals(newName)))
          .getSingleOrNull();
      if (clash != null) return false;
      await (_db.update(_db.tags)
            ..where((t) => t.id.equals(id)))
          .write(TagsCompanion(
        name: Value(newName),
        lastModified: Value(dbTime(.timestamp())),
      ));
      // diary_tags 按名字关联，同事务内同步改名（参数化语句防注入）
      await _db.customStatement(
        'UPDATE diary_tags SET tag = ? WHERE tag = ?',
        [newName, row.name],
      );
      return true;
    });
    if (updated) {
      final tag = await getTagById(id);
      if (tag != null) _events.add(TagUpserted(tag));
    }
    return updated;
  }

  /// 删除：被日记使用或有子标签时拒绝，返回 false。
  Future<bool> deleteATag(String id) async {
    final deleted = await _db.transaction(() async {
      final row = await (_db.select(
        _db.tags,
      )..where((t) => t.id.equals(id))).getSingleOrNull();
      if (row == null) return false;
      final inUse =
          await (_db.select(_db.diaryTags)
                ..where((d) => d.tag.equals(row.name))
                ..limit(1))
              .getSingleOrNull() !=
          null;
      if (inUse) return false;
      final hasChild =
          await (_db.select(_db.tags)
                ..where((t) => t.parentId.equals(id))
                ..limit(1))
              .getSingleOrNull() !=
          null;
      if (hasChild) return false;
      await (_db.delete(_db.tags)..where((t) => t.id.equals(id))).go();
      await _db.into(_db.tombstones).insertOnConflictUpdate(
        TombstonesCompanion.insert(
          key: SyncTombstone.tagKey(id),
          timeMs: SyncTombstone.forTag(id, at: .timestamp()).timeMs,
          pushedBackendsJson: const Value('[]'),
        ),
      );
      return true;
    });
    if (deleted) _events.add(TagDeleted(id));
    return deleted;
  }
}
