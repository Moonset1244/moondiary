import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:moodiary_data/moodiary_data.dart';
import 'package:moodiary_i18n/moodiary_i18n.dart';
import 'package:moodiary_models/moodiary_models.dart';
import 'package:moodiary_router/moodiary_router.dart';
import 'package:moodiary_storage/moodiary_storage.dart';
import 'package:mui/mui.dart';

class DiarySettingPage extends StatelessWidget {
  const DiarySettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.app.diarySettings)),
      body: Padding(
        padding: const .symmetric(horizontal: 8.0),
        child: CustomScrollView(
          slivers: [
            MSliverSettingGroup(
              title: context.l10n.app.diaryPrefsEditor,
              children: [
                _KvSwitchTile(
                  kv: .firstLineIndent,
                  title: context.l10n.app.firstLineIndent,
                ),
                _KvSwitchTile(
                  kv: .showWritingTime,
                  title: context.l10n.app.showWritingTime,
                ),
                _KvSwitchTile(
                  kv: .showWordCount,
                  title: context.l10n.app.showWordCount,
                ),
                _KvSwitchTile(
                  kv: .enterBreaks,
                  title: context.l10n.app.enterBreaks,
                  subtitle: context.l10n.app.enterBreaksSubtitle,
                ),
                SettingListTile(
                  title: context.l10n.editor.toolbar.settingsTitle,
                  trailing: Icon(
                    LucideIcons.chevronRight,
                    color: context.theme.colors.onSurfaceVariant,
                  ),
                  onTap: () => const EditorToolbarSettingRoute().push(context),
                ),
              ],
            ),
            MSliverSettingGroup(
              title: context.l10n.app.diaryPrefsDefault,
              children: const [
                _DefaultCategoryTile(),
                _DefaultTagsTile(),
                _AutoTitleTile(),
              ],
            ),
            MSliverSettingGroup(
              title: context.l10n.app.diaryPrefsMeta,
              children: [
                _KvSwitchTile(
                  kv: .showMetaWeather,
                  title: context.l10n.app.showMetaWeather,
                ),
                _KvSwitchTile(
                  kv: .showMetaPosition,
                  title: context.l10n.app.showMetaPosition,
                ),
                _KvSwitchTile(
                  kv: .showMetaCategory,
                  title: context.l10n.app.showMetaCategory,
                ),
                _KvSwitchTile(
                  kv: .showMetaTags,
                  title: context.l10n.app.showMetaTags,
                ),
                _KvSwitchTile(
                  kv: .showMetaMood,
                  title: context.l10n.app.showMetaMood,
                ),
                _KvSwitchTile(
                  kv: .extractHashtags,
                  title: context.l10n.app.extractHashtags,
                  subtitle: context.l10n.app.extractHashtagsSubtitle,
                ),
                _KvSwitchTile(
                  kv: .showHomeCalendar,
                  title: context.l10n.app.showHomeCalendar,
                ),
                _KvSwitchTile(
                  kv: .autoFormat,
                  title: context.l10n.app.autoFormat,
                  subtitle: context.l10n.app.autoFormatSubtitle,
                ),
              ],
            ),
            MSliverSettingGroup(
              title: context.l10n.app.diaryPrefsWeather,
              children: [
                _KvSwitchTile(
                  kv: .autoWeather,
                  title: context.l10n.app.autoWeather,
                  subtitle: context.l10n.app.autoWeatherSubtitle,
                ),
                _KvSwitchTile(
                  kv: .autoPosition,
                  title: context.l10n.app.autoPosition,
                  subtitle: context.l10n.app.autoPositionSubtitle,
                ),
                _KvSwitchTile(
                  kv: .autoNearestPlace,
                  title: context.l10n.app.autoNearestPlace,
                  subtitle: context.l10n.app.autoNearestPlaceSubtitle,
                ),
              ],
            ),
            SliverGap(context.safeBottom),
          ],
        ),
      ),
    );
  }
}

class _KvSwitchTile extends StatelessWidget {
  final MoodiaryKVs<bool> kv;
  final String title;
  final String? subtitle;

  const _KvSwitchTile({required this.kv, required this.title, this.subtitle});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: kv.getNotifier(),
      builder: (context, value, _) {
        return SettingSwitchListTile(
          title: title,
          subtitle: subtitle,
          value: value,
          onChanged: (v) => kv.set(v),
        );
      },
    );
  }
}

class _DefaultCategoryTile extends ConsumerWidget {
  const _DefaultCategoryTile();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ref.watch(orderedCategoriesProvider).value ?? const [];
    return ValueListenableBuilder(
      valueListenable: MoodiaryKVs.defaultCategoryId.getNotifierOr(''),
      builder: (context, id, _) {
        Category? current;
        for (final c in categories) {
          if (c.id == id) current = c;
        }
        return SettingListTile(
          title: context.l10n.app.defaultCategory,
          subtitle: current?.categoryName ?? context.l10n.app.defaultNone,
          trailing: Icon(
            LucideIcons.chevronRight,
            color: context.theme.colors.onSurfaceVariant,
          ),
          onTap: () => _pick(context, categories),
        );
      },
    );
  }

  Future<void> _pick(BuildContext context, List<Category> categories) async {
    final selected = await MAlert.show<String>(
      context,
      title: context.l10n.app.defaultCategory,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            dense: true,
            title: Text(context.l10n.app.defaultNone),
            onTap: () => Navigator.of(context).pop(''),
          ),
          for (final c in categories)
            ListTile(
              dense: true,
              title: Text(c.categoryName),
              onTap: () => Navigator.of(context).pop(c.id),
            ),
        ],
      ),
      actions: [MAction(label: context.l10n.common.cancel, value: '')],
    );
    if (selected == null || selected.isEmpty) return;
    MoodiaryKVs.defaultCategoryId.set(selected);
  }
}

class _DefaultTagsTile extends ConsumerWidget {
  const _DefaultTagsTile();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tags = ref.watch(tagControllerProvider).value ?? const [];
    return ValueListenableBuilder(
      valueListenable: MoodiaryKVs.defaultTags.getNotifierOr(const []),
      builder: (context, current, _) {
        final list = current.toList();
        final names = list.join('、');
        return SettingListTile(
          title: context.l10n.app.defaultTags,
          subtitle: names.isEmpty ? context.l10n.app.defaultNone : names,
          trailing: Icon(
            LucideIcons.chevronRight,
            color: context.theme.colors.onSurfaceVariant,
          ),
          onTap: () => _pick(context, tags, list),
        );
      },
    );
  }

  Future<void> _pick(
    BuildContext context,
    List<Tag> tags,
    List<String> current,
  ) async {
    final selected = {...current};
    final ok = await MAlert.show<bool>(
      context,
      title: context.l10n.app.defaultTags,
      content: StatefulBuilder(
        builder: (context, setState) => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final t in tags)
              CheckboxListTile(
                dense: true,
                title: Text(t.name),
                value: selected.contains(t.name),
                onChanged: (v) => setState(() {
                  if (v == true) {
                    selected.add(t.name);
                  } else {
                    selected.remove(t.name);
                  }
                }),
              ),
          ],
        ),
      ),
      actions: [
        MAction(label: context.l10n.common.cancel, value: false),
        MAction(label: context.l10n.common.ok, value: true),
      ],
    );
    if (ok != true) return;
    MoodiaryKVs.defaultTags.set(selected.toList());
  }
}

class _AutoTitleTile extends StatelessWidget {
  const _AutoTitleTile();

  static String _label(BuildContext context, int mode) => switch (mode) {
    1 => context.l10n.app.autoTitleFirstSentence,
    2 => context.l10n.app.autoTitleDateTime,
    3 => context.l10n.app.autoTitleTemplate,
    _ => context.l10n.app.autoTitleNone,
  };

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: MoodiaryKVs.autoTitleMode.getNotifierOr(0),
      builder: (context, mode, _) {
        return SettingListTile(
          title: context.l10n.app.autoTitle,
          subtitle: _label(context, mode),
          trailing: Icon(
            LucideIcons.chevronRight,
            color: context.theme.colors.onSurfaceVariant,
          ),
          onTap: () => _pick(context, mode),
        );
      },
    );
  }

  Future<void> _pick(BuildContext context, int current) async {
    final selected = await MAlert.show<int>(
      context,
      title: context.l10n.app.autoTitle,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final mode in const [0, 1, 2, 3])
            ListTile(
              dense: true,
              leading: Icon(
                current == mode ? LucideIcons.circleCheck : LucideIcons.circle,
                size: 20,
              ),
              title: Text(_label(context, mode)),
              onTap: () => Navigator.of(context).pop(mode),
            ),
        ],
      ),
      actions: [MAction(label: context.l10n.common.cancel, value: -1)],
    );
    if (selected == null || selected < 0) return;
    MoodiaryKVs.autoTitleMode.set(selected);
    if (selected == 3 && context.mounted) {
      await _editTemplate(context);
    }
  }

  Future<void> _editTemplate(BuildContext context) async {
    final controller = TextEditingController(
      text: MoodiaryKVs.autoTitleTemplate.get() ?? 'yyyy-MM-dd HH:mm:ss',
    );
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.l10n.app.autoTitleTemplate),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: controller,
              autofocus: true,
              decoration: InputDecoration(
                hintText: context.l10n.app.autoTitleTemplateHint,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(context.l10n.common.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(controller.text),
            child: Text(context.l10n.common.ok),
          ),
        ],
      ),
    );
    if (result != null && result.isNotEmpty) {
      MoodiaryKVs.autoTitleTemplate.set(result);
    }
  }
}
