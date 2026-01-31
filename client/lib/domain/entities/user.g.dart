// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_User _$UserFromJson(Map<String, dynamic> json) => _User(
  id: json['_id'] as String,
  email: json['email'] as String,
  timezone: json['timezone'] as String? ?? 'UTC',
  preferences: json['preferences'] as Map<String, dynamic>? ?? const {},
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$UserToJson(_User instance) => <String, dynamic>{
  '_id': instance.id,
  'email': instance.email,
  'timezone': instance.timezone,
  'preferences': instance.preferences,
  'createdAt': instance.createdAt?.toIso8601String(),
};
