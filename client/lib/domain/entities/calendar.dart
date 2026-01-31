import 'package:freezed_annotation/freezed_annotation.dart';

part 'calendar.freezed.dart';
part 'calendar.g.dart';

@freezed
abstract class Calendar with _$Calendar {
  const factory Calendar({
    required String id,
    required String name,
    required String color,
    String? ownerId,
    DateTime? createdAt,
  }) = _Calendar;

  factory Calendar.fromJson(Map<String, dynamic> json) =>
      _$CalendarFromJson(json);
}
