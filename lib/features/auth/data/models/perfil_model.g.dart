// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'perfil_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PerfilModelImpl _$$PerfilModelImplFromJson(Map<String, dynamic> json) =>
    _$PerfilModelImpl(
      id: (json['id'] as num).toInt(),
      perfil: json['perfil'] as String? ?? '',
      slug: json['slug'] as String? ?? '',
      principal: json['principal'] as bool? ?? false,
    );

Map<String, dynamic> _$$PerfilModelImplToJson(_$PerfilModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'perfil': instance.perfil,
      'slug': instance.slug,
      'principal': instance.principal,
    };
