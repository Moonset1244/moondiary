// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'diary_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(DiaryController)
final diaryControllerProvider = DiaryControllerFamily._();

final class DiaryControllerProvider
    extends $AsyncNotifierProvider<DiaryController, List<Diary>> {
  DiaryControllerProvider._({
    required DiaryControllerFamily super.from,
    required ({String? categoryId, bool uncategorized, String? tag})
    super.argument,
  }) : super(
         retry: null,
         name: r'diaryControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$diaryControllerHash();

  @override
  String toString() {
    return r'diaryControllerProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  DiaryController create() => DiaryController();

  @override
  bool operator ==(Object other) {
    return other is DiaryControllerProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$diaryControllerHash() => r'6e61fb687ca427dc51cf2e57ba5a57755eff9b64';

final class DiaryControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          DiaryController,
          AsyncValue<List<Diary>>,
          List<Diary>,
          FutureOr<List<Diary>>,
          ({String? categoryId, bool uncategorized, String? tag})
        > {
  DiaryControllerFamily._()
    : super(
        retry: null,
        name: r'diaryControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  DiaryControllerProvider call({
    String? categoryId,
    bool uncategorized = false,
    String? tag,
  }) => DiaryControllerProvider._(
    argument: (categoryId: categoryId, uncategorized: uncategorized, tag: tag),
    from: this,
  );

  @override
  String toString() => r'diaryControllerProvider';
}

abstract class _$DiaryController extends $AsyncNotifier<List<Diary>> {
  late final _$args =
      ref.$arg as ({String? categoryId, bool uncategorized, String? tag});
  String? get categoryId => _$args.categoryId;
  bool get uncategorized => _$args.uncategorized;
  String? get tag => _$args.tag;

  FutureOr<List<Diary>> build({
    String? categoryId,
    bool uncategorized = false,
    String? tag,
  });
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<Diary>>, List<Diary>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Diary>>, List<Diary>>,
              AsyncValue<List<Diary>>,
              Object?,
              Object?
            >;
    return element.handleCreate(
      ref,
      () => build(
        categoryId: _$args.categoryId,
        uncategorized: _$args.uncategorized,
        tag: _$args.tag,
      ),
    );
  }
}

@ProviderFor(RecycleBinDiaries)
final recycleBinDiariesProvider = RecycleBinDiariesProvider._();

final class RecycleBinDiariesProvider
    extends $AsyncNotifierProvider<RecycleBinDiaries, List<Diary>> {
  RecycleBinDiariesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'recycleBinDiariesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$recycleBinDiariesHash();

  @$internal
  @override
  RecycleBinDiaries create() => RecycleBinDiaries();
}

String _$recycleBinDiariesHash() => r'1da1572e21567036a215095dd7ccea7cb42f7fd6';

abstract class _$RecycleBinDiaries extends $AsyncNotifier<List<Diary>> {
  FutureOr<List<Diary>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<Diary>>, List<Diary>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Diary>>, List<Diary>>,
              AsyncValue<List<Diary>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(getDiary)
final getDiaryProvider = GetDiaryFamily._();

final class GetDiaryProvider
    extends $FunctionalProvider<AsyncValue<Diary?>, Diary?, Stream<Diary?>>
    with $FutureModifier<Diary?>, $StreamProvider<Diary?> {
  GetDiaryProvider._({
    required GetDiaryFamily super.from,
    required ({
      String? id,
      DiaryType? defaultType,
      String? defaultCategoryId,
      List<String>? defaultTags,
    })
    super.argument,
  }) : super(
         retry: null,
         name: r'getDiaryProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$getDiaryHash();

  @override
  String toString() {
    return r'getDiaryProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $StreamProviderElement<Diary?> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<Diary?> create(Ref ref) {
    final argument =
        this.argument
            as ({
              String? id,
              DiaryType? defaultType,
              String? defaultCategoryId,
              List<String>? defaultTags,
            });
    return getDiary(
      ref,
      id: argument.id,
      defaultType: argument.defaultType,
      defaultCategoryId: argument.defaultCategoryId,
      defaultTags: argument.defaultTags,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is GetDiaryProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$getDiaryHash() => r'620b86f2f6d09a39f7fd2a4959cc67f97eeb537c';

final class GetDiaryFamily extends $Family
    with
        $FunctionalFamilyOverride<
          Stream<Diary?>,
          ({
            String? id,
            DiaryType? defaultType,
            String? defaultCategoryId,
            List<String>? defaultTags,
          })
        > {
  GetDiaryFamily._()
    : super(
        retry: null,
        name: r'getDiaryProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  GetDiaryProvider call({
    String? id,
    DiaryType? defaultType,
    String? defaultCategoryId,
    List<String>? defaultTags,
  }) => GetDiaryProvider._(
    argument: (
      id: id,
      defaultType: defaultType,
      defaultCategoryId: defaultCategoryId,
      defaultTags: defaultTags,
    ),
    from: this,
  );

  @override
  String toString() => r'getDiaryProvider';
}
