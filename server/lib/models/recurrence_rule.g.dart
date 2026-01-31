// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recurrence_rule.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RecurrenceRule _$RecurrenceRuleFromJson(Map<String, dynamic> json) =>
    _RecurrenceRule(
      frequency: $enumDecode(_$FrequencyEnumMap, json['frequency']),
      interval: (json['interval'] as num?)?.toInt() ?? 1,
      count: (json['count'] as num?)?.toInt(),
      until: json['until'] == null
          ? null
          : DateTime.parse(json['until'] as String),
      byWeekDay: (json['byWeekDay'] as List<dynamic>?)
              ?.map((e) => (e as num).toInt())
              .toList() ??
          const [],
      byMonthDay: (json['byMonthDay'] as List<dynamic>?)
              ?.map((e) => (e as num).toInt())
              .toList() ??
          const [],
      byMonth: (json['byMonth'] as List<dynamic>?)
              ?.map((e) => (e as num).toInt())
              .toList() ??
          const [],
    );

Map<String, dynamic> _$RecurrenceRuleToJson(_RecurrenceRule instance) =>
    <String, dynamic>{
      'frequency': _$FrequencyEnumMap[instance.frequency]!,
      'interval': instance.interval,
      'count': instance.count,
      'until': instance.until?.toIso8601String(),
      'byWeekDay': instance.byWeekDay,
      'byMonthDay': instance.byMonthDay,
      'byMonth': instance.byMonth,
    };

const _$FrequencyEnumMap = {
  Frequency.daily: 'daily',
  Frequency.weekly: 'weekly',
  Frequency.monthly: 'monthly',
  Frequency.yearly: 'yearly',
};
