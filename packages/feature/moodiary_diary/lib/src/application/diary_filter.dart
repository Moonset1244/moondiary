import 'package:flutter_riverpod/flutter_riverpod.dart';

class DiaryFilter {
  final String? categoryId;

  final bool uncategorized;

  final String? tag;

  final DateTime? day;

  const DiaryFilter._(this.categoryId, this.uncategorized, this.tag, this.day);

  const DiaryFilter.all() : this._(null, false, null, null);

  const DiaryFilter.category(String id) : this._(id, false, null, null);

  const DiaryFilter.uncategorized() : this._(null, true, null, null);

  const DiaryFilter.tag(String name) : this._(null, false, name, null);

  const DiaryFilter.day(DateTime day) : this._(null, false, null, day);

  bool get isAll =>
      categoryId == null && !uncategorized && tag == null && day == null;

  @override
  bool operator ==(Object other) =>
      other is DiaryFilter &&
      other.categoryId == categoryId &&
      other.uncategorized == uncategorized &&
      other.tag == tag &&
      other.day == day;

  @override
  int get hashCode => Object.hash(categoryId, uncategorized, tag, day);

  @override
  String toString() => isAll
      ? 'DiaryFilter.all()'
      : uncategorized
      ? 'DiaryFilter.uncategorized()'
      : tag != null
      ? 'DiaryFilter.tag($tag)'
      : day != null
      ? 'DiaryFilter.day($day)'
      : 'DiaryFilter.category($categoryId)';
}

class DiaryFilterNotifier extends Notifier<DiaryFilter> {
  @override
  DiaryFilter build() => const .all();

  void select(DiaryFilter filter) => state = filter;

  void reset() => state = const .all();
}

final homeDiaryFilterProvider =
    NotifierProvider<DiaryFilterNotifier, DiaryFilter>(DiaryFilterNotifier.new);
