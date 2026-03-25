// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'perfil_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PerfilModel _$PerfilModelFromJson(Map<String, dynamic> json) {
  return _PerfilModel.fromJson(json);
}

/// @nodoc
mixin _$PerfilModel {
  int get id => throw _privateConstructorUsedError;
  String get perfil => throw _privateConstructorUsedError;
  String get slug => throw _privateConstructorUsedError;
  bool get principal => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PerfilModelCopyWith<PerfilModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PerfilModelCopyWith<$Res> {
  factory $PerfilModelCopyWith(
          PerfilModel value, $Res Function(PerfilModel) then) =
      _$PerfilModelCopyWithImpl<$Res, PerfilModel>;
  @useResult
  $Res call({int id, String perfil, String slug, bool principal});
}

/// @nodoc
class _$PerfilModelCopyWithImpl<$Res, $Val extends PerfilModel>
    implements $PerfilModelCopyWith<$Res> {
  _$PerfilModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? perfil = null,
    Object? slug = null,
    Object? principal = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      perfil: null == perfil
          ? _value.perfil
          : perfil // ignore: cast_nullable_to_non_nullable
              as String,
      slug: null == slug
          ? _value.slug
          : slug // ignore: cast_nullable_to_non_nullable
              as String,
      principal: null == principal
          ? _value.principal
          : principal // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PerfilModelImplCopyWith<$Res>
    implements $PerfilModelCopyWith<$Res> {
  factory _$$PerfilModelImplCopyWith(
          _$PerfilModelImpl value, $Res Function(_$PerfilModelImpl) then) =
      __$$PerfilModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int id, String perfil, String slug, bool principal});
}

/// @nodoc
class __$$PerfilModelImplCopyWithImpl<$Res>
    extends _$PerfilModelCopyWithImpl<$Res, _$PerfilModelImpl>
    implements _$$PerfilModelImplCopyWith<$Res> {
  __$$PerfilModelImplCopyWithImpl(
      _$PerfilModelImpl _value, $Res Function(_$PerfilModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? perfil = null,
    Object? slug = null,
    Object? principal = null,
  }) {
    return _then(_$PerfilModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      perfil: null == perfil
          ? _value.perfil
          : perfil // ignore: cast_nullable_to_non_nullable
              as String,
      slug: null == slug
          ? _value.slug
          : slug // ignore: cast_nullable_to_non_nullable
              as String,
      principal: null == principal
          ? _value.principal
          : principal // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PerfilModelImpl extends _PerfilModel {
  const _$PerfilModelImpl(
      {required this.id,
      this.perfil = '',
      this.slug = '',
      this.principal = false})
      : super._();

  factory _$PerfilModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$PerfilModelImplFromJson(json);

  @override
  final int id;
  @override
  @JsonKey()
  final String perfil;
  @override
  @JsonKey()
  final String slug;
  @override
  @JsonKey()
  final bool principal;

  @override
  String toString() {
    return 'PerfilModel(id: $id, perfil: $perfil, slug: $slug, principal: $principal)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PerfilModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.perfil, perfil) || other.perfil == perfil) &&
            (identical(other.slug, slug) || other.slug == slug) &&
            (identical(other.principal, principal) ||
                other.principal == principal));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, perfil, slug, principal);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PerfilModelImplCopyWith<_$PerfilModelImpl> get copyWith =>
      __$$PerfilModelImplCopyWithImpl<_$PerfilModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PerfilModelImplToJson(
      this,
    );
  }
}

abstract class _PerfilModel extends PerfilModel {
  const factory _PerfilModel(
      {required final int id,
      final String perfil,
      final String slug,
      final bool principal}) = _$PerfilModelImpl;
  const _PerfilModel._() : super._();

  factory _PerfilModel.fromJson(Map<String, dynamic> json) =
      _$PerfilModelImpl.fromJson;

  @override
  int get id;
  @override
  String get perfil;
  @override
  String get slug;
  @override
  bool get principal;
  @override
  @JsonKey(ignore: true)
  _$$PerfilModelImplCopyWith<_$PerfilModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
