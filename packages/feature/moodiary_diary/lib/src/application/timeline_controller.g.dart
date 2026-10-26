// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timeline_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(timelineMonthCounts)
final timelineMonthCountsProvider = TimelineMonthCountsFamily._();

final class TimelineMonthCountsProvider
    extends
        $FunctionalProvider<
          AsyncValue<Map<DateTime, int>>,
          Map<DateTime, int>,
          FutureOr<Map<DateTime, int>>
        >
    with
        $FutureModifier<Map<DateTime, int>>,
        $FutureProvider<Map<DateTime, int>> {
  TimelineMonthCountsProvider._({
    required TimelineMonthCountsFamily super.from,
    required ({
      String? categoryId,
      bool uncategorized,
      String? tag,
      DiarySort sort,
    })
    super.argument,
  }) : super(
         retry: null,
         name: r'timelineMonthCountsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$timelineMonthCountsHash();

  @override
  String toString() {
    return r'timelineMonthCountsProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<Map<DateTime, int>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Map<DateTime, int>> create(Ref ref) {
    final argument =
        this.argument
            as ({
              String? categoryId,
              bool uncategorized,
              String? tag,
              DiarySort sort,
            });
    return timelineMonthCounts(
      ref,
      categoryId: argument.categoryId,
      uncategorized: argument.uncategorized,
      tag: argument.tag,
      sort: argument.sort,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is TimelineMonthCountsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$timelineMonthCountsHash() =>
    r'2824c1b00f1f2952a5cb208450718964efddbfd2';

final class TimelineMonthCountsFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<Map<DateTime, int>>,
          ({
            String? categoryId,
            bool uncategorized,
            String? tag,
            DiarySort sort,
          })
        > {
  TimelineMonthCountsFamily._()
    : super(
        retry: null,
        name: r'timelineMonthCountsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  TimelineMonthCountsProvider call({
    String? categoryId,
    bool uncategorized = false,
    String? tag,
    required DiarySort sort,
  }) => TimelineMonthCountsProvider._(
    argument: (
      categoryId: categoryId,
      uncategorized: uncategorized,
      tag: tag,
      sort: sort,
    ),
    from: this,
  );

  @override
  String toString() => r'timelineMonthCountsProvider';
}

/// 按天统计（主页日历条）。

@ProviderFor(homeDayCounts)
final homeDayCountsProvider = HomeDayCountsFamily._();

/// 按天统计（主页日历条）。

final class HomeDayCountsProvider
    extends
        $FunctionalProvider<
          AsyncValue<Map<DateTime, int>>,
          Map<DateTime, int>,
          FutureOr<Map<DateTime, int>>
        >
    with
        $FutureModifier<Map<DateTime, int>>,
        $FutureProvider<Map<DateTime, int>> {
  /// 按天统计（主页日历条）。
  HomeDayCountsProvider._({
    required HomeDayCountsFamily super.from,
    required ({String? categoryId, bool uncategorized, String? tag})
    super.argument,
  }) : super(
         retry: null,
         name: r'homeDayCountsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$homeDayCountsHash();

  @override
  String toString() {
    return r'homeDayCountsProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<Map<DateTime, int>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Map<DateTime, int>> create(Ref ref) {
    final argument =
        this.argument
            as ({String? categoryId, bool uncategorized, String? tag});
    return homeDayCounts(
      ref,
      categoryId: argument.categoryId,
      uncategorized: argument.uncategorized,
      tag: argument.tag,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is HomeDayCountsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$homeDayCountsHash() => r'ad08d0377f7267fd30126fadfac68477bab693d4';

/// 按天统计（主页日历条）。

final class HomeDayCountsFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<Map<DateTime, int>>,
          ({String? categoryId, bool uncategorized, String? tag})
        > {
  HomeDayCountsFamily._()
    : super(
        retry: null,
        name: r'homeDayCountsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// 按天统计（主页日历条）。

  HomeDayCountsProvider call({
    String? categoryId,
    bool uncategorized = false,
    String? tag,
  }) => HomeDayCountsProvider._(
    argument: (categoryId: categoryId, uncategorized: uncategorized, tag: tag),
    from: this,
  );

  @override
  String toString() => r'homeDayCountsProvider';
}
