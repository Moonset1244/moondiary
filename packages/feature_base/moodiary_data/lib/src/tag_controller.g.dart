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

String _$tagControllerHash() => r'4a534e15c66e02d8e90a1476a4eed4972a1db07d';

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
