import 'package:freezed_annotation/freezed_annotation.dart';

import 'tag.dart';

part 'tag_event.freezed.dart';

@freezed
sealed class TagEvent with _$TagEvent {
  const factory TagEvent.upserted(Tag tag, {@Default(false) bool fromSync}) =
      TagUpserted;

  const factory TagEvent.deleted(String id, {@Default(false) bool fromSync}) =
      TagDeleted;
}
