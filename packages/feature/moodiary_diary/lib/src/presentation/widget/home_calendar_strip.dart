import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moodiary_diary/src/application/diary_filter.dart';
import 'package:moodiary_diary/src/application/timeline_controller.dart';
import 'package:moodiary_i18n/moodiary_i18n.dart';
import 'package:mui/mui.dart';

/// 主页顶部日历条：本周一行，展开显示本月，点击某天筛选当天日记。
class HomeCalendarStrip extends ConsumerStatefulWidget {
  final DiaryFilter filter;

  const HomeCalendarStrip({super.key, required this.filter});

  @override
  ConsumerState<HomeCalendarStrip> createState() => _HomeCalendarStripState();
}

class _HomeCalendarStripState extends ConsumerState<HomeCalendarStrip> {
  bool _expanded = false;
  late DateTime _displayMonth;

  DateTime get _today {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  DateTime get _monthAnchor {
    final anchor = widget.filter.day ?? _today;
    return DateTime(anchor.year, anchor.month);
  }

  @override
  void initState() {
    super.initState();
    _displayMonth = _monthAnchor;
  }

  @override
  void didUpdateWidget(covariant HomeCalendarStrip oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.filter.day != widget.filter.day) {
      _displayMonth = _monthAnchor;
    }
  }

  void _pickDay(DateTime day) {
    final filter = widget.filter;
    final already = filter.day != null && _sameDay(filter.day!, day);
    ref
        .read(homeDiaryFilterProvider.notifier)
        .select(already ? const DiaryFilter.all() : DiaryFilter.day(day));
  }

  void _shiftMonth(int delta) {
    setState(() {
      _displayMonth = DateTime(_displayMonth.year, _displayMonth.month + delta);
    });
  }

  @override
  Widget build(BuildContext context) {
    final counts =
        ref
            .watch(
              homeDayCountsProvider(
                categoryId: widget.filter.categoryId,
                uncategorized: widget.filter.uncategorized,
                tag: widget.filter.tag,
              ),
            )
            .value ??
        const {};
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _WeekStrip(
          today: _today,
          selected: widget.filter.day,
          counts: counts,
          onPick: _pickDay,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () => setState(() => _expanded = !_expanded),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _expanded ? LucideIcons.chevronUp : LucideIcons.chevronDown,
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    _expanded
                        ? context.l10n.diary.calendarCollapse
                        : context.l10n.diary.calendarExpand,
                    style: context.theme.typography.labelSmall.onSurfaceVariant,
                  ),
                ],
              ),
            ),
            if (_expanded) ...[
              const SizedBox(width: 8),
              TextButton(
                onPressed: _pickAnyDate,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(LucideIcons.calendarDays, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      context.l10n.diary.calendarPickDate,
                      style: context.theme.typography.labelSmall.primary,
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
        if (_expanded)
          _MonthGrid(
            month: _displayMonth,
            today: _today,
            selected: widget.filter.day,
            counts: counts,
            onPick: _pickDay,
            onShiftMonth: _shiftMonth,
          ),
      ],
    );
  }

  Future<void> _pickAnyDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: widget.filter.day ?? _today,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) _pickDay(picked);
  }
}

class _WeekStrip extends StatelessWidget {
  final DateTime today;
  final DateTime? selected;
  final Map<DateTime, int> counts;
  final ValueChanged<DateTime> onPick;

  const _WeekStrip({
    required this.today,
    required this.selected,
    required this.counts,
    required this.onPick,
  });

  @override
  Widget build(BuildContext context) {
    // 本周周一到周日
    final monday = today.subtract(Duration(days: today.weekday - 1));
    final days = [for (var i = 0; i < 7; i++) monday.add(Duration(days: i))];
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 6, 8, 2),
      child: Row(
        children: [
          for (final day in days)
            Expanded(
              child: _DayCell(
                day: day,
                isToday: _sameDay(day, today),
                selected: selected != null && _sameDay(day, selected!),
                count: counts[day] ?? 0,
                onTap: () => onPick(day),
              ),
            ),
        ],
      ),
    );
  }
}

class _DayCell extends StatelessWidget {
  final DateTime day;
  final bool isToday;
  final bool selected;
  final int count;
  final VoidCallback onTap;

  const _DayCell({
    required this.day,
    required this.isToday,
    required this.selected,
    required this.count,
    required this.onTap,
  });

  static const _weekdayLabels = ['一', '二', '三', '四', '五', '六', '日'];

  @override
  Widget build(BuildContext context) {
    final colors = context.theme.colors;
    final typo = context.theme.typography;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _weekdayLabels[day.weekday - 1],
              style: typo.labelSmall.onSurfaceVariant,
            ),
            const SizedBox(height: 2),
            Container(
              width: 28,
              height: 28,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: selected
                    ? colors.primary
                    : isToday
                    ? colors.secondaryContainer
                    : null,
                shape: BoxShape.circle,
              ),
              child: Text(
                '${day.day}',
                style:
                    (selected
                            ? typo.labelMedium.onPrimary
                            : typo.labelMedium.onSurface)
                        .copyWith(
                          fontFeatures: const [.tabularFigures()],
                        ),
              ),
            ),
            const SizedBox(height: 2),
            SizedBox(
              height: 4,
              child: count > 0
                  ? Container(
                      width: 4,
                      height: 4,
                      decoration: BoxDecoration(
                        color: colors.primary,
                        shape: BoxShape.circle,
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}

class _MonthGrid extends StatelessWidget {
  final DateTime month;
  final DateTime today;
  final DateTime? selected;
  final Map<DateTime, int> counts;
  final ValueChanged<DateTime> onPick;
  final ValueChanged<int> onShiftMonth;

  const _MonthGrid({
    required this.month,
    required this.today,
    required this.selected,
    required this.counts,
    required this.onPick,
    required this.onShiftMonth,
  });

  @override
  Widget build(BuildContext context) {
    final year = month.year;
    final mon = month.month;
    final first = DateTime(year, mon, 1);
    final daysInMonth = DateTime(year, mon + 1, 0).day;
    // 起始：周一对齐（weekday 1=周一）
    final leading = first.weekday - 1;
    final cells = <DateTime?>[
      for (var i = 0; i < leading; i++) null,
      for (var d = 1; d <= daysInMonth; d++) DateTime(year, mon, d),
    ];
    while (cells.length % 7 != 0) {
      cells.add(null);
    }
    final typo = context.theme.typography;
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 6),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(LucideIcons.chevronLeft, size: 18),
                onPressed: () => onShiftMonth(-1),
              ),
              Expanded(
                child: Text(
                  '$year 年 $mon 月',
                  textAlign: TextAlign.center,
                  style: typo.labelMedium.onSurface,
                ),
              ),
              IconButton(
                icon: const Icon(LucideIcons.chevronRight, size: 18),
                onPressed: () => onShiftMonth(1),
              ),
            ],
          ),
          GridView.count(
            crossAxisCount: 7,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            childAspectRatio: 1.0,
            children: [
              for (final cell in cells)
                if (cell == null)
                  const SizedBox.shrink()
                else
                  _MonthDayCell(
                    day: cell,
                    isToday: _sameDay(cell, today),
                    selected: selected != null && _sameDay(cell, selected!),
                    count: counts[cell] ?? 0,
                    onTap: () => onPick(cell),
                  ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MonthDayCell extends StatelessWidget {
  final DateTime day;
  final bool isToday;
  final bool selected;
  final int count;
  final VoidCallback onTap;

  const _MonthDayCell({
    required this.day,
    required this.isToday,
    required this.selected,
    required this.count,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.theme.colors;
    final typo = context.theme.typography;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        margin: const EdgeInsets.all(1),
        decoration: BoxDecoration(
          color: selected ? colors.primary : null,
          borderRadius: BorderRadius.circular(8),
          border: isToday && !selected
              ? Border.all(color: colors.primary, width: 1.2)
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${day.day}',
              style:
                  (selected
                          ? typo.labelMedium.onPrimary
                          : typo.labelMedium.onSurface)
                      .copyWith(
                        fontFeatures: const [.tabularFigures()],
                      ),
            ),
            if (count > 0)
              Container(
                width: 3,
                height: 3,
                margin: const EdgeInsets.only(top: 1),
                decoration: BoxDecoration(
                  color: selected ? colors.onPrimary : colors.primary,
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

bool _sameDay(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month && a.day == b.day;
