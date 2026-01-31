import 'package:freezed_annotation/freezed_annotation.dart';

part 'recurrence_rule.freezed.dart';
part 'recurrence_rule.g.dart';

enum Frequency { daily, weekly, monthly, yearly }

@freezed
class RecurrenceRule with _$RecurrenceRule {
  const factory RecurrenceRule({
    required Frequency frequency,
    @Default(1) int interval,
    int? count,
    DateTime? until,
    @Default([]) List<int> byWeekDay, // 0 = Sunday, 6 = Saturday
    @Default([]) List<int> byMonthDay,
    @Default([]) List<int> byMonth,
  }) = _RecurrenceRule;

  factory RecurrenceRule.fromJson(Map<String, dynamic> json) =>
      _$RecurrenceRuleFromJson(json);

  // Parse simplified RRULE string
  factory RecurrenceRule.fromRRULE(String rrule) {
    final parts = rrule.split(';');
    Frequency? freq;
    int interval = 1;
    int? count;
    DateTime? until;
    final byWeekDay = <int>[];
    final byMonthDay = <int>[];
    final byMonth = <int>[];

    for (final part in parts) {
      final kv = part.split('=');
      if (kv.length != 2) continue;

      final key = kv[0];
      final value = kv[1];

      switch (key) {
        case 'FREQ':
          freq = Frequency.values.firstWhere(
            (f) => f.name.toUpperCase() == value.toUpperCase(),
            orElse: () => Frequency.daily,
          );
          break;
        case 'INTERVAL':
          interval = int.tryParse(value) ?? 1;
          break;
        case 'COUNT':
          count = int.tryParse(value);
          break;
        case 'UNTIL':
          until = DateTime.tryParse(value);
          break;
        case 'BYDAY':
          // Parse days like MO,TU,WE
          final days = value.split(',');
          for (final day in days) {
            switch (day.toUpperCase()) {
              case 'SU':
                byWeekDay.add(0);
                break;
              case 'MO':
                byWeekDay.add(1);
                break;
              case 'TU':
                byWeekDay.add(2);
                break;
              case 'WE':
                byWeekDay.add(3);
                break;
              case 'TH':
                byWeekDay.add(4);
                break;
              case 'FR':
                byWeekDay.add(5);
                break;
              case 'SA':
                byWeekDay.add(6);
                break;
            }
          }
          break;
        case 'BYMONTHDAY':
          byMonthDay.addAll(value.split(',').map((s) => int.parse(s)));
          break;
        case 'BYMONTH':
          byMonth.addAll(value.split(',').map((s) => int.parse(s)));
          break;
      }
    }

    return RecurrenceRule(
      frequency: freq ?? Frequency.daily,
      interval: interval,
      count: count,
      until: until,
      byWeekDay: byWeekDay,
      byMonthDay: byMonthDay,
      byMonth: byMonth,
    );
  }

  // Convert to RRULE string
  String toRRULE() {
    final parts = <String>[];
    parts.add('FREQ=${frequency.name.toUpperCase()}');

    if (interval > 1) {
      parts.add('INTERVAL=$interval');
    }

    if (count != null) {
      parts.add('COUNT=$count');
    }

    if (until != null) {
      parts.add('UNTIL=${until!.toIso8601String()}');
    }

    if (byWeekDay.isNotEmpty) {
      const dayNames = ['SU', 'MO', 'TU', 'WE', 'TH', 'FR', 'SA'];
      final days = byWeekDay.map((d) => dayNames[d]).join(',');
      parts.add('BYDAY=$days');
    }

    if (byMonthDay.isNotEmpty) {
      parts.add('BYMONTHDAY=${byMonthDay.join(',')}');
    }

    if (byMonth.isNotEmpty) {
      parts.add('BYMONTH=${byMonth.join(',')}');
    }

    return parts.join(';');
  }
}
