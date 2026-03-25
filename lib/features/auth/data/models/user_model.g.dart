// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserModelImpl _$$UserModelImplFromJson(Map<String, dynamic> json) =>
    _$UserModelImpl(
      id: (json['id'] as num).toInt(),
      email: json['email'] as String,
      username: json['username'] as String,
      firstName: json['first_name'] as String? ?? '',
      lastName: json['last_name'] as String? ?? '',
      isVerified: json['is_verified'] as bool? ?? false,
      dateJoined: DateTime.parse(json['date_joined'] as String),
      persona: json['persona'] == null
          ? null
          : PersonaModel.fromJson(json['persona'] as Map<String, dynamic>),
      perfiles: (json['perfiles'] as List<dynamic>?)
              ?.map((e) => PerfilModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$UserModelImplToJson(_$UserModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'username': instance.username,
      'first_name': instance.firstName,
      'last_name': instance.lastName,
      'is_verified': instance.isVerified,
      'date_joined': instance.dateJoined.toIso8601String(),
      'persona': instance.persona,
      'perfiles': instance.perfiles,
    };
