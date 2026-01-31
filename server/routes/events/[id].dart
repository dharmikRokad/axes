import 'dart:async';
import 'dart:io';

import 'package:axes_server/repositories/event_repository.dart';
import 'package:dart_frog/dart_frog.dart';

Future<Response> onRequest(RequestContext context, String id) async {
  final eventRepo = context.read<EventRepository>();

  switch (context.request.method) {
    case HttpMethod.patch:
      final body = await context.request.json() as Map<String, dynamic>;
      final updated = await eventRepo.updateEvent(id, body);
      if (updated == null) {
        return Response(statusCode: HttpStatus.notFound);
      }
      return Response.json(body: updated.toJson());

    case HttpMethod.delete:
      await eventRepo.deleteEvent(id);
      return Response(statusCode: HttpStatus.noContent);

    default:
      return Response(statusCode: HttpStatus.methodNotAllowed);
  }
}
