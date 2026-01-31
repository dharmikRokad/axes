import 'dart:async';
import 'dart:io';

import 'package:axes_server/repositories/calendar_repository.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:mongo_dart/mongo_dart.dart';

Future<Response> onRequest(RequestContext context) async {
  // Authentication check (basic manual check, could be middleware)
  final authHeader = context.request.headers['Authorization'];
  if (authHeader == null || !authHeader.startsWith('Bearer ')) {
    return Response(statusCode: HttpStatus.unauthorized);
  }

  final calendarRepo = context.read<CalendarRepository>();

  switch (context.request.method) {
    case HttpMethod.get:
      return _getCalendars(context, calendarRepo);
    case HttpMethod.post:
      return _createCalendar(context, calendarRepo);
    default:
      return Response(statusCode: HttpStatus.methodNotAllowed);
  }
}

Future<Response> _getCalendars(
  RequestContext context,
  CalendarRepository repo,
) async {
  // TODO: Extract ownerId from JWT
  final ownerId = 'TODO_USER_ID';
  final calendars = await repo.getCalendars(ownerId);

  // Transform ObjectId to String and DateTime to ISO string
  final result = calendars.map((c) {
    c['id'] = (c['_id'] as ObjectId).toHexString();
    c.remove('_id');
    // Convert DateTime to ISO string
    if (c['createdAt'] is DateTime) {
      c['createdAt'] = (c['createdAt'] as DateTime).toIso8601String();
    }
    return c;
  }).toList();

  return Response.json(body: result);
}

Future<Response> _createCalendar(
  RequestContext context,
  CalendarRepository repo,
) async {
  final body = await context.request.json() as Map<String, dynamic>;
  final id = ObjectId();
  final now = DateTime.now();
  final calendar = {
    '_id': id,
    'name': body['name'] as String,
    'color': body['color'] as String,
    'ownerId': 'TODO_USER_ID', // Extract from token
    'createdAt': now,
  };

  await repo.createCalendar(calendar);

  // Return JSON-serializable response
  return Response.json(
    body: {
      'id': id.toHexString(),
      'name': body['name'],
      'color': body['color'],
      'ownerId': 'TODO_USER_ID',
      'createdAt': now.toIso8601String(),
    },
  );
}
