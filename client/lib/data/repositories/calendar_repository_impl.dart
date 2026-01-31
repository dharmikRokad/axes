import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../domain/entities/calendar.dart';
import '../../domain/repositories/calendar_repository.dart';

class CalendarRepositoryImpl implements CalendarRepository {
  final Dio _dio;

  CalendarRepositoryImpl(this._dio);

  @override
  Future<Either<String, List<Calendar>>> getCalendars() async {
    try {
      final response = await _dio.get('/calendars');
      final List data = response.data;
      final calendars = data.map((e) => Calendar.fromJson(e)).toList();
      return right(calendars);
    } catch (e) {
      return left(e.toString());
    }
  }

  @override
  Future<Either<String, Calendar>> createCalendar(
    String name,
    String color,
  ) async {
    try {
      final response = await _dio.post(
        '/calendars',
        data: {'name': name, 'color': color},
      );
      return right(Calendar.fromJson(response.data));
    } catch (e) {
      return left(e.toString());
    }
  }

  @override
  Future<Either<String, Unit>> updateCalendar(
    String id,
    String name,
    String color,
  ) async {
    try {
      await _dio.patch('/calendars/$id', data: {'name': name, 'color': color});
      return right(unit);
    } catch (e) {
      return left(e.toString());
    }
  }

  @override
  Future<Either<String, Unit>> deleteCalendar(String id) async {
    try {
      await _dio.delete('/calendars/$id');
      return right(unit);
    } catch (e) {
      return left(e.toString());
    }
  }
}
