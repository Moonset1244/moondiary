import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:moodiary_utils/moodiary_utils.dart';

import 'utc_date_time_converter.dart';

part 'tag.freezed.dart';
part 'tag.g.dart';

/// 多级标签（自记）。与 Category 同构：id/名字/最后修改/父级/颜色；
/// 日记仍通过 diary_tags 按名字关联，重命名由仓储层事务同步。
@freezed
abstract class Tag with _$Tag {
  const factory Tag({
    required String id,
    required String name,
    @UtcDateTimeConverter() required DateTime lastModified,
    String? parentId,
    int? color,
  }) = _Tag;

  const Tag._();

  factory Tag.create({required String name, String? parentId, int? color}) {
    return Tag(
      id: uuidV7(),
      name: name,
      lastModified: .timestamp(),
      parentId: parentId,
      color: color,
    );
  }

  factory Tag.fromJson(Map<String, dynamic> json) => _$TagFromJson(json);
}
