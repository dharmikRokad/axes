import 'package:freezed_annotation/freezed_annotation.dart';

part 'event.freezed.dart';
part 'event.g.dart';

@freezed
abstract class Event with _$Event {
  const factory Event({
    @JsonKey(name: '_id') required String id,
    required String calendarId,
    String? baseEventId, // For recurring event instances
    required String title,
    @Default('') String description,
    @Default('') String location,
    required DateTime startDateTime,
    required DateTime endDateTime,
    @Default(false) bool allDay,
    @Default('UTC') String timezone,
    String? recurrenceRule, // RRULE string
    @Default(false) bool isException,
    DateTime? recurrenceExceptionDate,
    @Default([]) List<Map<String, dynamic>> reminders,
    required DateTime createdAt,
    required DateTime updatedAt,
    DateTime? deletedAt,
  }) = _Event;

  factory Event.fromJson(Map<String, dynamic> json) => _$EventFromJson(json);
}
