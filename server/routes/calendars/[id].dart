import 'dart:async';
import 'dart:io';

import 'package:axes_server/repositories/calendar_repository.dart';
import 'package:dart_frog/dart_frog.dart';

Future<Response> onRequest(RequestContext context, String id) async {
  final calendarRepo = context.read<CalendarRepository>();

  switch (context.request.method) {
    case HttpMethod.patch:
      return _updateCalendar(context, calendarRepo, id);
    case HttpMethod.delete:
      return _deleteCalendar(context, calendarRepo, id);
    default:
      return Response(statusCode: HttpStatus.methodNotAllowed);
  }
}

Future<Response> _updateCalendar(
  RequestContext context,
  CalendarRepository repo,
  String id,
) async {
  final body = await context.request.json() as Map<String, dynamic>;
  final updates = <String, dynamic>{};

  if (body.containsKey('name')) updates['name'] = body['name'];
  if (body.containsKey('color')) updates['color'] = body['color'];

  if (updates.isEmpty) {
    return Response.json(
      statusCode: HttpStatus.badRequest,
      body: {'error': 'No updates provided'},
    );
  }

  await repo.updateCalendar(id, updates);
  return Response(statusCode: HttpStatus.noContent);
}

Future<Response> _deleteCalendar(
  RequestContext context,
  CalendarRepository repo,
  String id,
) async {
  await repo.deleteCalendar(id);
  return Response(statusCode: HttpStatus.noContent);
}
