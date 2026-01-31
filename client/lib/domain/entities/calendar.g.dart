// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'calendar.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Calendar _$CalendarFromJson(Map<String, dynamic> json) => _Calendar(
  id: json['id'] as String,
  name: json['name'] as String,
  color: json['color'] as String,
  ownerId: json['ownerId'] as String?,
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$CalendarToJson(_Calendar instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'color': instance.color,
  'ownerId': instance.ownerId,
  'createdAt': instance.createdAt?.toIso8601String(),
};
