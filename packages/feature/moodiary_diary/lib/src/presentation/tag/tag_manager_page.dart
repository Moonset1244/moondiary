import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moodiary_components/moodiary_components.dart';
import 'package:moodiary_data/moodiary_data.dart';
import 'package:moodiary_i18n/moodiary_i18n.dart';
import 'package:moodiary_models/moodiary_models.dart';

import '../category/category_manager_page.dart' show showCategoryEditor;

/// 标签管理（自记多级标签）：层级列表 + 新建/改名/换父级/颜色/删除。
class TagManagerPage extends ConsumerStatefulWidget {
  const TagManagerPage({super.key});

  @override
  ConsumerState<TagManagerPage> createState() => _TagManagerPageState();
}

class _TagManagerPageState extends ConsumerState<TagManagerPage> {
  @override
  Widget build(BuildContext context) {
    final async = ref.watch(tagControllerProvider);
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.diary.tagManagerTitle)),
      floatingActionButton: FloatingActionButton(
        heroTag: 'tagManagerFab',
        onPressed: () => _onAdd(parent: null),
        child: const Icon(LucideIcons.plus),
      ),
      body: async.buildLoading(
        data: (tags) {
          if (tags.isEmpty) {
            return Center(child: Text(context.l10n.diary.tagEmpty));
          }
          final tree = tagTree(tags);
          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(12, 4, 12, 88),
            itemCount: tree.length,
            itemBuilder: (context, index) {
              final entry = tree.entries.elementAt(index);
              final parent = tags.firstWhere((t) => t.id == entry.key);
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _TagTile(
                    tag: parent,
                    trailing: '${entry.value.length}',
                    onAddChild: () => _onAdd(parent: entry.key),
                    onRename: () => _onRename(parent),
                    onReparent: () => _onReparent(parent, tags),
                    onDelete: () => _onDelete(parent),
                  ),
                  for (final child in entry.value)
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: _TagTile(
                        tag: child,
                        onAddChild: null,
                        onRename: () => _onRename(child),
                        onReparent: () => _onReparent(child, tags),
                        onDelete: () => _onDelete(child),
                      ),
                    ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _onAdd({String? parent}) async {
    final draft = await showCategoryEditor(
      context,
      initialName: '',
      initialColor: null,
    );
    if (draft == null || draft.name.isEmpty) return;
    final ok = await ref
        .read(tagControllerProvider.notifier)
        .upsertTag(
          Tag.create(name: draft.name, color: draft.color, parentId: parent),
        );
    if (!mounted) return;
    if (ok) {
      toast.success(
        message: context.l10n.diary.categoryCreated(name: draft.name),
      );
    } else {
      toast.error(message: context.l10n.diary.tagCreateFailed);
    }
  }

  Future<void> _onRename(Tag tag) async {
    final draft = await showCategoryEditor(
      context,
      initialName: tag.name,
      initialColor: tag.color,
    );
    if (draft == null) return;
    if (draft.name != tag.name) {
      final ok = await ref
          .read(tagControllerProvider.notifier)
          .renameTag(tag.id, draft.name);
      if (!mounted) return;
      if (!ok) {
        toast.error(message: context.l10n.diary.categoryRenameFailed);
        return;
      }
    }
    if (draft.color != tag.color) {
      await ref
          .read(tagControllerProvider.notifier)
          .upsertTag(
            tag.copyWith(
              color: draft.color,
              lastModified: DateTime.timestamp(),
            ),
          );
    }
    if (mounted) {
      toast.success(
        message: context.l10n.diary.categoryRenamed(name: draft.name),
      );
    }
  }

  Future<void> _onReparent(Tag tag, List<Tag> all) async {
    final candidates = all
        .where((t) => t.id != tag.id && t.parentId == null)
        .toList();
    const kNone = '__none__';
    final target = await MAlert.show<String>(
      context,
      title: context.l10n.diary.tagSetParent,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            dense: true,
            title: Text(context.l10n.diary.tagNoParent),
            onTap: () => Navigator.of(context).pop(kNone),
          ),
          for (final c in candidates)
            ListTile(
              dense: true,
              title: Text(c.name),
              onTap: () => Navigator.of(context).pop(c.id),
            ),
        ],
      ),
      actions: [MAction(label: context.l10n.common.cancel, value: '')],
    );
    if (target == null || target.isEmpty) return;
    final newParent = target == kNone ? null : target;
    if (newParent == tag.parentId) return;
    await ref
        .read(tagControllerProvider.notifier)
        .upsertTag(
          tag.copyWith(parentId: newParent, lastModified: DateTime.timestamp()),
        );
  }

  Future<void> _onDelete(Tag tag) async {
    final confirmed = await MAlert.confirm(
      context,
      title: context.l10n.diary.tagDeleteTitle,
      message: tag.name,
      confirmLabel: context.l10n.common.delete,
      isDestructive: true,
    );
    if (!confirmed) return;
    final ok = await ref.read(tagControllerProvider.notifier).deleteTag(tag.id);
    if (!mounted) return;
    if (!ok) {
      toast.error(message: context.l10n.diary.tagDeleteBlocked);
    }
  }
}

class _TagTile extends StatelessWidget {
  final Tag tag;
  final String? trailing;
  final VoidCallback? onAddChild;
  final VoidCallback onRename;
  final VoidCallback onReparent;
  final VoidCallback onDelete;

  const _TagTile({
    required this.tag,
    required this.onRename,
    required this.onReparent,
    required this.onDelete,
    this.trailing,
    this.onAddChild,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.theme.colors;
    return Card.filled(
      margin: const EdgeInsets.symmetric(vertical: 4),
      color: colors.surfaceContainerLow,
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        onTap: onRename,
        leading: tag.parentId == null
            ? const Icon(LucideIcons.tag, size: 21)
            : const Padding(
                padding: EdgeInsets.only(left: 12),
                child: Icon(LucideIcons.cornerDownRight, size: 18),
              ),
        title: Text(
          tag.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: context.theme.typography.titleMedium.onSurface,
        ),
        subtitle: trailing == null
            ? null
            : Text(
                trailing!,
                style: context.theme.typography.labelSmall.onSurfaceVariant,
              ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (tag.color != null)
              Container(
                width: 10,
                height: 10,
                margin: const EdgeInsets.only(right: 4),
                decoration: BoxDecoration(
                  color: Color(tag.color!),
                  shape: BoxShape.circle,
                ),
              ),
            if (onAddChild != null)
              IconButton(
                icon: const Icon(LucideIcons.plus, size: 18),
                tooltip: context.l10n.diary.tagNew,
                onPressed: onAddChild,
              ),
            PopupMenuButton<String>(
              icon: const Icon(LucideIcons.moreHorizontal, size: 18),
              onSelected: (v) {
                switch (v) {
                  case 'rename':
                    onRename();
                  case 'reparent':
                    onReparent();
                  case 'delete':
                    onDelete();
                }
              },
              itemBuilder: (_) => [
                PopupMenuItem(
                  value: 'rename',
                  child: Text(context.l10n.diary.tagRename),
                ),
                PopupMenuItem(
                  value: 'reparent',
                  child: Text(context.l10n.diary.tagSetParent),
                ),
                PopupMenuItem(
                  value: 'delete',
                  child: Text(context.l10n.common.delete),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
