import 'package:dartz/dartz.dart';
import '../entities/calendar.dart';

abstract class CalendarRepository {
  Future<Either<String, List<Calendar>>> getCalendars();
  Future<Either<String, Calendar>> createCalendar(String name, String color);
  Future<Either<String, Unit>> updateCalendar(
    String id,
    String name,
    String color,
  );
  Future<Either<String, Unit>> deleteCalendar(String id);
}
