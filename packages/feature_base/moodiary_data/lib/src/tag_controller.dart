import 'dart:async';

import 'package:moodiary_di/moodiary_di.dart';
import 'package:moodiary_logging/moodiary_logging.dart';
import 'package:moodiary_models/moodiary_models.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'tag_repository.dart';

part 'tag_controller.g.dart';

List<Tag> _applyEvent(List<Tag> list, TagEvent event) {
  switch (event) {
    case TagDeleted(:final id):
      if (!list.any((t) => t.id == id)) return list;
      return list.where((t) => t.id != id).toList();
    case TagUpserted(:final tag):
      final index = list.indexWhere((t) => t.id == tag.id);
      final updated = [...list];
      if (index == -1) {
        updated.add(tag);
      } else {
        updated[index] = tag;
      }
      updated.sort((a, b) => a.name.compareTo(b.name));
      return updated;
  }
}

@riverpod
class TagController extends _$TagController {
  late final _repository = getIt<TagRepository>();

  bool _missedEvent = false;

  @override
  FutureOr<List<Tag>> build() async {
    final sub = _repository.tagEvents.listen(_applyChange);
    ref.onDispose(sub.cancel);
    var list = await _repository.getAllTags();
    for (var i = 0; _missedEvent && i < 3; i++) {
      _missedEvent = false;
      list = await _repository.getAllTags();
    }
    return list;
  }

  void _applyChange(TagEvent event) {
    final list = state.value;
    if (list == null) {
      _missedEvent = true;
      return;
    }
    state = .data(_applyEvent(list, event));
  }

  Future<bool> upsertTag(Tag tag) async {
    try {
      await _repository.insertATag(tag);
      return true;
    } catch (e) {
      logger.e('upsertTag failed', error: e);
      return false;
    }
  }

  Future<bool> renameTag(String id, String newName) =>
      _repository.renameTag(id, newName);

  Future<bool> deleteTag(String id) async {
    try {
      return await _repository.deleteATag(id);
    } catch (e) {
      logger.e('deleteTag failed', error: e);
      return false;
    }
  }
}

/// 层级树视图：父标签 -> 子标签列表（保持名字序）。
Map<String?, List<Tag>> tagTree(List<Tag> tags) {
  final sorted = [...tags]..sort((a, b) => a.name.compareTo(b.name));
  return {
    for (final parent in sorted.where((t) => t.parentId == null))
      parent.id: sorted.where((t) => t.parentId == parent.id).toList(),
  };
}
