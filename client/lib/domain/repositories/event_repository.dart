import 'package:dartz/dartz.dart';
import '../entities/event.dart';

abstract class EventRepository {
  Future<Either<String, List<Event>>> getEvents({
    List<String>? calendarIds,
    DateTime? from,
    DateTime? to,
  });

  Future<Either<String, Event>> createEvent(Event event);
  Future<Either<String, Event>> updateEvent(
    String id,
    Map<String, dynamic> updates,
  );
  Future<Either<String, Unit>> deleteEvent(String id);
}
