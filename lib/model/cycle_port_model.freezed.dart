// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'cycle_port_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CyclePort _$CyclePortFromJson(Map<String, dynamic> json) {
  return _CyclePort.fromJson(json);
}

/// @nodoc
mixin _$CyclePort {
  String get name => throw _privateConstructorUsedError;
  String get rent => throw _privateConstructorUsedError;
  String get returnNumber => throw _privateConstructorUsedError;
  String get lat => throw _privateConstructorUsedError;
  String get lng => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CyclePortCopyWith<CyclePort> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CyclePortCopyWith<$Res> {
  factory $CyclePortCopyWith(CyclePort value, $Res Function(CyclePort) then) =
      _$CyclePortCopyWithImpl<$Res, CyclePort>;
  @useResult
  $Res call(
      {String name, String rent, String returnNumber, String lat, String lng});
}

/// @nodoc
class _$CyclePortCopyWithImpl<$Res, $Val extends CyclePort>
    implements $CyclePortCopyWith<$Res> {
  _$CyclePortCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? rent = null,
    Object? returnNumber = null,
    Object? lat = null,
    Object? lng = null,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      rent: null == rent
          ? _value.rent
          : rent // ignore: cast_nullable_to_non_nullable
              as String,
      returnNumber: null == returnNumber
          ? _value.returnNumber
          : returnNumber // ignore: cast_nullable_to_non_nullable
              as String,
      lat: null == lat
          ? _value.lat
          : lat // ignore: cast_nullable_to_non_nullable
              as String,
      lng: null == lng
          ? _value.lng
          : lng // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CyclePortImplCopyWith<$Res>
    implements $CyclePortCopyWith<$Res> {
  factory _$$CyclePortImplCopyWith(
          _$CyclePortImpl value, $Res Function(_$CyclePortImpl) then) =
      __$$CyclePortImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String name, String rent, String returnNumber, String lat, String lng});
}

/// @nodoc
class __$$CyclePortImplCopyWithImpl<$Res>
    extends _$CyclePortCopyWithImpl<$Res, _$CyclePortImpl>
    implements _$$CyclePortImplCopyWith<$Res> {
  __$$CyclePortImplCopyWithImpl(
      _$CyclePortImpl _value, $Res Function(_$CyclePortImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? rent = null,
    Object? returnNumber = null,
    Object? lat = null,
    Object? lng = null,
  }) {
    return _then(_$CyclePortImpl(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      rent: null == rent
          ? _value.rent
          : rent // ignore: cast_nullable_to_non_nullable
              as String,
      returnNumber: null == returnNumber
          ? _value.returnNumber
          : returnNumber // ignore: cast_nullable_to_non_nullable
              as String,
      lat: null == lat
          ? _value.lat
          : lat // ignore: cast_nullable_to_non_nullable
              as String,
      lng: null == lng
          ? _value.lng
          : lng // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CyclePortImpl implements _CyclePort {
  const _$CyclePortImpl(
      {required this.name,
      required this.rent,
      required this.returnNumber,
      required this.lat,
      required this.lng});

  factory _$CyclePortImpl.fromJson(Map<String, dynamic> json) =>
      _$$CyclePortImplFromJson(json);

  @override
  final String name;
  @override
  final String rent;
  @override
  final String returnNumber;
  @override
  final String lat;
  @override
  final String lng;

  @override
  String toString() {
    return 'CyclePort(name: $name, rent: $rent, returnNumber: $returnNumber, lat: $lat, lng: $lng)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CyclePortImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.rent, rent) || other.rent == rent) &&
            (identical(other.returnNumber, returnNumber) ||
                other.returnNumber == returnNumber) &&
            (identical(other.lat, lat) || other.lat == lat) &&
            (identical(other.lng, lng) || other.lng == lng));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, name, rent, returnNumber, lat, lng);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CyclePortImplCopyWith<_$CyclePortImpl> get copyWith =>
      __$$CyclePortImplCopyWithImpl<_$CyclePortImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CyclePortImplToJson(
      this,
    );
  }
}

abstract class _CyclePort implements CyclePort {
  const factory _CyclePort(
      {required final String name,
      required final String rent,
      required final String returnNumber,
      required final String lat,
      required final String lng}) = _$CyclePortImpl;

  factory _CyclePort.fromJson(Map<String, dynamic> json) =
      _$CyclePortImpl.fromJson;

  @override
  String get name;
  @override
  String get rent;
  @override
  String get returnNumber;
  @override
  String get lat;
  @override
  String get lng;
  @override
  @JsonKey(ignore: true)
  _$$CyclePortImplCopyWith<_$CyclePortImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
