// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tag_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TagEvent {

 bool get fromSync;
/// Create a copy of TagEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TagEventCopyWith<TagEvent> get copyWith => _$TagEventCopyWithImpl<TagEvent>(this as TagEvent, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as TagEvent;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TagEvent&&(identical(other.fromSync, _this.fromSync) || other.fromSync == _this.fromSync));
}


@override
int get hashCode {
  final _this = this as TagEvent;
  return Object.hash(runtimeType,_this.fromSync);
}

@override
String toString() {
  final _this = this as TagEvent;
  return 'TagEvent(fromSync: ${_this.fromSync})';
}


}

/// @nodoc
abstract mixin class $TagEventCopyWith<$Res>  {
  factory $TagEventCopyWith(TagEvent value, $Res Function(TagEvent) _then) = _$TagEventCopyWithImpl;
@useResult
$Res call({
 bool fromSync
});




}
/// @nodoc
class _$TagEventCopyWithImpl<$Res>
    implements $TagEventCopyWith<$Res> {
  _$TagEventCopyWithImpl(this._self, this._then);

  final TagEvent _self;
  final $Res Function(TagEvent) _then;

/// Create a copy of TagEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? fromSync = null,}) {
  return _then(_self.copyWith(
fromSync: null == fromSync ? _self.fromSync : fromSync // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [TagEvent].
extension TagEventPatterns on TagEvent {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( TagUpserted value)?  upserted,TResult Function( TagDeleted value)?  deleted,required TResult orElse(),}){
final _that = this;
switch (_that) {
case TagUpserted() when upserted != null:
return upserted(_that);case TagDeleted() when deleted != null:
return deleted(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( TagUpserted value)  upserted,required TResult Function( TagDeleted value)  deleted,}){
final _that = this;
switch (_that) {
case TagUpserted():
return upserted(_that);case TagDeleted():
return deleted(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( TagUpserted value)?  upserted,TResult? Function( TagDeleted value)?  deleted,}){
final _that = this;
switch (_that) {
case TagUpserted() when upserted != null:
return upserted(_that);case TagDeleted() when deleted != null:
return deleted(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( Tag tag,  bool fromSync)?  upserted,TResult Function( String id,  bool fromSync)?  deleted,required TResult orElse(),}) {final _that = this;
switch (_that) {
case TagUpserted() when upserted != null:
return upserted(_that.tag,_that.fromSync);case TagDeleted() when deleted != null:
return deleted(_that.id,_that.fromSync);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( Tag tag,  bool fromSync)  upserted,required TResult Function( String id,  bool fromSync)  deleted,}) {final _that = this;
switch (_that) {
case TagUpserted():
return upserted(_that.tag,_that.fromSync);case TagDeleted():
return deleted(_that.id,_that.fromSync);}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( Tag tag,  bool fromSync)?  upserted,TResult? Function( String id,  bool fromSync)?  deleted,}) {final _that = this;
switch (_that) {
case TagUpserted() when upserted != null:
return upserted(_that.tag,_that.fromSync);case TagDeleted() when deleted != null:
return deleted(_that.id,_that.fromSync);case _:
  return null;

}
}

}

/// @nodoc


class TagUpserted implements TagEvent {
  const TagUpserted(this.tag, {this.fromSync = false});
  

 final  Tag tag;
@override@JsonKey() final  bool fromSync;

/// Create a copy of TagEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TagUpsertedCopyWith<TagUpserted> get copyWith => _$TagUpsertedCopyWithImpl<TagUpserted>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is TagUpserted&&(identical(other.tag, tag) || other.tag == tag)&&(identical(other.fromSync, fromSync) || other.fromSync == fromSync));
}


@override
int get hashCode {
    return Object.hash(runtimeType,tag,fromSync);
}

@override
String toString() {
    return 'TagEvent.upserted(tag: $tag, fromSync: $fromSync)';
}


}

/// @nodoc
abstract mixin class $TagUpsertedCopyWith<$Res> implements $TagEventCopyWith<$Res> {
  factory $TagUpsertedCopyWith(TagUpserted value, $Res Function(TagUpserted) _then) = _$TagUpsertedCopyWithImpl;
@override @useResult
$Res call({
 Tag tag, bool fromSync
});


$TagCopyWith<$Res> get tag;

}
/// @nodoc
class _$TagUpsertedCopyWithImpl<$Res>
    implements $TagUpsertedCopyWith<$Res> {
  _$TagUpsertedCopyWithImpl(this._self, this._then);

  final TagUpserted _self;
  final $Res Function(TagUpserted) _then;

/// Create a copy of TagEvent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? tag = null,Object? fromSync = null,}) {
  return _then(TagUpserted(
null == tag ? _self.tag : tag // ignore: cast_nullable_to_non_nullable
as Tag,fromSync: null == fromSync ? _self.fromSync : fromSync // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of TagEvent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TagCopyWith<$Res> get tag {
  
  return $TagCopyWith<$Res>(_self.tag, (value) {
    return _then(_self.copyWith(tag: value));
  });
}
}

/// @nodoc


class TagDeleted implements TagEvent {
  const TagDeleted(this.id, {this.fromSync = false});
  

 final  String id;
@override@JsonKey() final  bool fromSync;

/// Create a copy of TagEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TagDeletedCopyWith<TagDeleted> get copyWith => _$TagDeletedCopyWithImpl<TagDeleted>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is TagDeleted&&(identical(other.id, id) || other.id == id)&&(identical(other.fromSync, fromSync) || other.fromSync == fromSync));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,fromSync);
}

@override
String toString() {
    return 'TagEvent.deleted(id: $id, fromSync: $fromSync)';
}


}

/// @nodoc
abstract mixin class $TagDeletedCopyWith<$Res> implements $TagEventCopyWith<$Res> {
  factory $TagDeletedCopyWith(TagDeleted value, $Res Function(TagDeleted) _then) = _$TagDeletedCopyWithImpl;
@override @useResult
$Res call({
 String id, bool fromSync
});




}
/// @nodoc
class _$TagDeletedCopyWithImpl<$Res>
    implements $TagDeletedCopyWith<$Res> {
  _$TagDeletedCopyWithImpl(this._self, this._then);

  final TagDeleted _self;
  final $Res Function(TagDeleted) _then;

/// Create a copy of TagEvent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? fromSync = null,}) {
  return _then(TagDeleted(
null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,fromSync: null == fromSync ? _self.fromSync : fromSync // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
