// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tag_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(TagController)
final tagControllerProvider = TagControllerProvider._();

final class TagControllerProvider
    extends $AsyncNotifierProvider<TagController, List<Tag>> {
  TagControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'tagControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$tagControllerHash();

  @$internal
  @override
  TagController create() => TagController();
}

String _$tagControllerHash() => r'9d074544536641a6afd4cf9b5af7dda7128c67df';

abstract class _$TagController extends $AsyncNotifier<List<Tag>> {
  FutureOr<List<Tag>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<Tag>>, List<Tag>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Tag>>, List<Tag>>,
              AsyncValue<List<Tag>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// 每个标签名对应的可见日记数（自记侧边栏标签区块）。

@ProviderFor(tagDiaryCounts)
final tagDiaryCountsProvider = TagDiaryCountsProvider._();

/// 每个标签名对应的可见日记数（自记侧边栏标签区块）。

final class TagDiaryCountsProvider
    extends
        $FunctionalProvider<
          AsyncValue<Map<String, int>>,
          Map<String, int>,
          FutureOr<Map<String, int>>
        >
    with $FutureModifier<Map<String, int>>, $FutureProvider<Map<String, int>> {
  /// 每个标签名对应的可见日记数（自记侧边栏标签区块）。
  TagDiaryCountsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'tagDiaryCountsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$tagDiaryCountsHash();

  @$internal
  @override
  $FutureProviderElement<Map<String, int>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Map<String, int>> create(Ref ref) {
    return tagDiaryCounts(ref);
  }
}

String _$tagDiaryCountsHash() => r'23f02f38e0b77c875be2013292ccb66c1120b5ec';
