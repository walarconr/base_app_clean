// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'persona_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PersonaModelImpl _$$PersonaModelImplFromJson(Map<String, dynamic> json) =>
    _$PersonaModelImpl(
      cedula: json['cedula'] as String? ?? '',
      nombres: json['nombres'] as String? ?? '',
      apellido1: json['apellido1'] as String? ?? '',
      apellido2: json['apellido2'] as String? ?? '',
      celular: json['celular'] as String? ?? '',
      telefono: json['telefono'] as String? ?? '',
      email: json['email'] as String? ?? '',
    );

Map<String, dynamic> _$$PersonaModelImplToJson(_$PersonaModelImpl instance) =>
    <String, dynamic>{
      'cedula': instance.cedula,
      'nombres': instance.nombres,
      'apellido1': instance.apellido1,
      'apellido2': instance.apellido2,
      'celular': instance.celular,
      'telefono': instance.telefono,
      'email': instance.email,
    };
