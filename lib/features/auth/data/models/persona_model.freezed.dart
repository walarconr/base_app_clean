// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'persona_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PersonaModel _$PersonaModelFromJson(Map<String, dynamic> json) {
  return _PersonaModel.fromJson(json);
}

/// @nodoc
mixin _$PersonaModel {
  String get cedula => throw _privateConstructorUsedError;
  String get nombres => throw _privateConstructorUsedError;
  String get apellido1 => throw _privateConstructorUsedError;
  String get apellido2 => throw _privateConstructorUsedError;
  String get celular => throw _privateConstructorUsedError;
  String get telefono => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PersonaModelCopyWith<PersonaModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PersonaModelCopyWith<$Res> {
  factory $PersonaModelCopyWith(
          PersonaModel value, $Res Function(PersonaModel) then) =
      _$PersonaModelCopyWithImpl<$Res, PersonaModel>;
  @useResult
  $Res call(
      {String cedula,
      String nombres,
      String apellido1,
      String apellido2,
      String celular,
      String telefono,
      String email});
}

/// @nodoc
class _$PersonaModelCopyWithImpl<$Res, $Val extends PersonaModel>
    implements $PersonaModelCopyWith<$Res> {
  _$PersonaModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? cedula = null,
    Object? nombres = null,
    Object? apellido1 = null,
    Object? apellido2 = null,
    Object? celular = null,
    Object? telefono = null,
    Object? email = null,
  }) {
    return _then(_value.copyWith(
      cedula: null == cedula
          ? _value.cedula
          : cedula // ignore: cast_nullable_to_non_nullable
              as String,
      nombres: null == nombres
          ? _value.nombres
          : nombres // ignore: cast_nullable_to_non_nullable
              as String,
      apellido1: null == apellido1
          ? _value.apellido1
          : apellido1 // ignore: cast_nullable_to_non_nullable
              as String,
      apellido2: null == apellido2
          ? _value.apellido2
          : apellido2 // ignore: cast_nullable_to_non_nullable
              as String,
      celular: null == celular
          ? _value.celular
          : celular // ignore: cast_nullable_to_non_nullable
              as String,
      telefono: null == telefono
          ? _value.telefono
          : telefono // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PersonaModelImplCopyWith<$Res>
    implements $PersonaModelCopyWith<$Res> {
  factory _$$PersonaModelImplCopyWith(
          _$PersonaModelImpl value, $Res Function(_$PersonaModelImpl) then) =
      __$$PersonaModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String cedula,
      String nombres,
      String apellido1,
      String apellido2,
      String celular,
      String telefono,
      String email});
}

/// @nodoc
class __$$PersonaModelImplCopyWithImpl<$Res>
    extends _$PersonaModelCopyWithImpl<$Res, _$PersonaModelImpl>
    implements _$$PersonaModelImplCopyWith<$Res> {
  __$$PersonaModelImplCopyWithImpl(
      _$PersonaModelImpl _value, $Res Function(_$PersonaModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? cedula = null,
    Object? nombres = null,
    Object? apellido1 = null,
    Object? apellido2 = null,
    Object? celular = null,
    Object? telefono = null,
    Object? email = null,
  }) {
    return _then(_$PersonaModelImpl(
      cedula: null == cedula
          ? _value.cedula
          : cedula // ignore: cast_nullable_to_non_nullable
              as String,
      nombres: null == nombres
          ? _value.nombres
          : nombres // ignore: cast_nullable_to_non_nullable
              as String,
      apellido1: null == apellido1
          ? _value.apellido1
          : apellido1 // ignore: cast_nullable_to_non_nullable
              as String,
      apellido2: null == apellido2
          ? _value.apellido2
          : apellido2 // ignore: cast_nullable_to_non_nullable
              as String,
      celular: null == celular
          ? _value.celular
          : celular // ignore: cast_nullable_to_non_nullable
              as String,
      telefono: null == telefono
          ? _value.telefono
          : telefono // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PersonaModelImpl extends _PersonaModel {
  const _$PersonaModelImpl(
      {this.cedula = '',
      this.nombres = '',
      this.apellido1 = '',
      this.apellido2 = '',
      this.celular = '',
      this.telefono = '',
      this.email = ''})
      : super._();

  factory _$PersonaModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$PersonaModelImplFromJson(json);

  @override
  @JsonKey()
  final String cedula;
  @override
  @JsonKey()
  final String nombres;
  @override
  @JsonKey()
  final String apellido1;
  @override
  @JsonKey()
  final String apellido2;
  @override
  @JsonKey()
  final String celular;
  @override
  @JsonKey()
  final String telefono;
  @override
  @JsonKey()
  final String email;

  @override
  String toString() {
    return 'PersonaModel(cedula: $cedula, nombres: $nombres, apellido1: $apellido1, apellido2: $apellido2, celular: $celular, telefono: $telefono, email: $email)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PersonaModelImpl &&
            (identical(other.cedula, cedula) || other.cedula == cedula) &&
            (identical(other.nombres, nombres) || other.nombres == nombres) &&
            (identical(other.apellido1, apellido1) ||
                other.apellido1 == apellido1) &&
            (identical(other.apellido2, apellido2) ||
                other.apellido2 == apellido2) &&
            (identical(other.celular, celular) || other.celular == celular) &&
            (identical(other.telefono, telefono) ||
                other.telefono == telefono) &&
            (identical(other.email, email) || other.email == email));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, cedula, nombres, apellido1,
      apellido2, celular, telefono, email);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PersonaModelImplCopyWith<_$PersonaModelImpl> get copyWith =>
      __$$PersonaModelImplCopyWithImpl<_$PersonaModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PersonaModelImplToJson(
      this,
    );
  }
}

abstract class _PersonaModel extends PersonaModel {
  const factory _PersonaModel(
      {final String cedula,
      final String nombres,
      final String apellido1,
      final String apellido2,
      final String celular,
      final String telefono,
      final String email}) = _$PersonaModelImpl;
  const _PersonaModel._() : super._();

  factory _PersonaModel.fromJson(Map<String, dynamic> json) =
      _$PersonaModelImpl.fromJson;

  @override
  String get cedula;
  @override
  String get nombres;
  @override
  String get apellido1;
  @override
  String get apellido2;
  @override
  String get celular;
  @override
  String get telefono;
  @override
  String get email;
  @override
  @JsonKey(ignore: true)
  _$$PersonaModelImplCopyWith<_$PersonaModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
