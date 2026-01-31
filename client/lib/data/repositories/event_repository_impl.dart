import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../domain/entities/event.dart';
import '../../domain/repositories/event_repository.dart';

class EventRepositoryImpl implements EventRepository {
  final Dio _dio;

  EventRepositoryImpl(this._dio);

  @override
  Future<Either<String, List<Event>>> getEvents({
    List<String>? calendarIds,
    DateTime? from,
    DateTime? to,
  }) async {
    try {
      final queryParams = <String, String>{};
      if (calendarIds != null && calendarIds.isNotEmpty) {
        queryParams['calendarIds'] = calendarIds.join(',');
      }
      if (from != null) {
        queryParams['from'] = from.toIso8601String();
      }
      if (to != null) {
        queryParams['to'] = to.toIso8601String();
      }

      final response = await _dio.get('/events', queryParameters: queryParams);
      final List data = response.data;
      final events = data.map((e) => Event.fromJson(e)).toList();
      return right(events);
    } catch (e) {
      return left(e.toString());
    }
  }

  @override
  Future<Either<String, Event>> createEvent(Event event) async {
    try {
      final response = await _dio.post('/events', data: event.toJson());
      return right(Event.fromJson(response.data));
    } catch (e) {
      return left(e.toString());
    }
  }

  @override
  Future<Either<String, Event>> updateEvent(
    String id,
    Map<String, dynamic> updates,
  ) async {
    try {
      final response = await _dio.patch('/events/$id', data: updates);
      return right(Event.fromJson(response.data));
    } catch (e) {
      return left(e.toString());
    }
  }

  @override
  Future<Either<String, Unit>> deleteEvent(String id) async {
    try {
      await _dio.delete('/events/$id');
      return right(unit);
    } catch (e) {
      return left(e.toString());
    }
  }
}
