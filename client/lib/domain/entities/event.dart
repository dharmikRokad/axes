import 'package:freezed_annotation/freezed_annotation.dart';

part 'event.freezed.dart';
part 'event.g.dart';

@freezed
abstract class Event with _$Event {
  const factory Event({
    required String id,
    required String calendarId,
    String? baseEventId,
    required String title,
    @Default('') String description,
    @Default('') String location,
    required DateTime startDateTime,
    required DateTime endDateTime,
    @Default(false) bool allDay,
    @Default('UTC') String timezone,
    String? recurrenceRule,
    @Default(false) bool isException,
    DateTime? recurrenceExceptionDate,
    @Default([]) List<Map<String, dynamic>> reminders,
  }) = _Event;

  factory Event.fromJson(Map<String, dynamic> json) => _$EventFromJson(json);
}
