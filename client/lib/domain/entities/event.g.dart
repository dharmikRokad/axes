// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Event _$EventFromJson(Map<String, dynamic> json) => _Event(
  id: json['_id'] as String,
  calendarId: json['calendarId'] as String,
  baseEventId: json['baseEventId'] as String?,
  title: json['title'] as String,
  description: json['description'] as String? ?? '',
  location: json['location'] as String? ?? '',
  startDateTime: DateTime.parse(json['startDateTime'] as String),
  endDateTime: DateTime.parse(json['endDateTime'] as String),
  allDay: json['allDay'] as bool? ?? false,
  timezone: json['timezone'] as String? ?? 'UTC',
  recurrenceRule: json['recurrenceRule'] as String?,
  isException: json['isException'] as bool? ?? false,
  recurrenceExceptionDate: json['recurrenceExceptionDate'] == null
      ? null
      : DateTime.parse(json['recurrenceExceptionDate'] as String),
  reminders:
      (json['reminders'] as List<dynamic>?)
          ?.map((e) => e as Map<String, dynamic>)
          .toList() ??
      const [],
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
  deletedAt: json['deletedAt'] == null
      ? null
      : DateTime.parse(json['deletedAt'] as String),
);

Map<String, dynamic> _$EventToJson(_Event instance) => <String, dynamic>{
  '_id': instance.id,
  'calendarId': instance.calendarId,
  'baseEventId': instance.baseEventId,
  'title': instance.title,
  'description': instance.description,
  'location': instance.location,
  'startDateTime': instance.startDateTime.toIso8601String(),
  'endDateTime': instance.endDateTime.toIso8601String(),
  'allDay': instance.allDay,
  'timezone': instance.timezone,
  'recurrenceRule': instance.recurrenceRule,
  'isException': instance.isException,
  'recurrenceExceptionDate': instance.recurrenceExceptionDate
      ?.toIso8601String(),
  'reminders': instance.reminders,
  'createdAt': instance.createdAt?.toIso8601String(),
  'updatedAt': instance.updatedAt?.toIso8601String(),
  'deletedAt': instance.deletedAt?.toIso8601String(),
};
