import 'dart:async';
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import '../../lib/repositories/event_repository.dart';
import '../../lib/models/event.dart';

Future<Response> onRequest(RequestContext context) async {
  // TODO: Verify auth token and extract userId

  switch (context.request.method) {
    case HttpMethod.get:
      return _getEvents(context);
    case HttpMethod.post:
      return _createEvent(context);
    default:
      return Response(statusCode: HttpStatus.methodNotAllowed);
  }
}

Future<Response> _getEvents(RequestContext context) async {
  final eventRepo = context.read<EventRepository>();

  final queryParams = context.request.uri.queryParameters;
  final calendarIds = queryParams['calendarIds']?.split(',');
  final fromStr = queryParams['from'];
  final toStr = queryParams['to'];

  DateTime? from;
  DateTime? to;

  if (fromStr != null) {
    from = DateTime.tryParse(fromStr);
  }
  if (toStr != null) {
    to = DateTime.tryParse(toStr);
  }

  final events = await eventRepo.getEvents(
    calendarIds: calendarIds,
    from: from,
    to: to,
  );

  return Response.json(body: events.map((e) => e.toJson()).toList());
}

Future<Response> _createEvent(RequestContext context) async {
  final eventRepo = context.read<EventRepository>();
  final body = await context.request.json() as Map<String, dynamic>;

  // Basic validation
  if (body['title'] == null || body['calendarId'] == null) {
    return Response.json(
      statusCode: HttpStatus.badRequest,
      body: {'error': 'title and calendarId are required'},
    );
  }

  final now = DateTime.now();
  final event = Event(
    id: '', // Will be set by repository
    calendarId: body['calendarId'],
    title: body['title'],
    description: body['description'] ?? '',
    location: body['location'] ?? '',
    startDateTime: DateTime.parse(body['startDateTime']),
    endDateTime: DateTime.parse(body['endDateTime']),
    allDay: body['allDay'] ?? false,
    timezone: body['timezone'] ?? 'UTC',
    createdAt: now,
    updatedAt: now,
  );

  final created = await eventRepo.createEvent(event);
  return Response.json(body: created.toJson());
}
