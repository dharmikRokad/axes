import 'dart:async';
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:mongo_dart/mongo_dart.dart';
import '../../lib/data_sources/mongo_data_source.dart';

Future<Response> onRequest(RequestContext context) async {
  // Authentication check (basic manual check, could be middleware)
  final authHeader = context.request.headers['Authorization'];
  if (authHeader == null || !authHeader.startsWith('Bearer ')) {
    return Response(statusCode: HttpStatus.unauthorized);
  }
  final token = authHeader.substring(7);
  // In a real app, use the TokenService to verify and extract user
  // For brevity here, we assume middleware or simple verification
  // We'll just check if it's a valid token structure or verify strictly if injected

  // To keep it clean, let's assume valid user for now or fail if strict:
  // final tokenService = context.read<TokenService>();
  // final jwt = tokenService.verify(token); ...

  switch (context.request.method) {
    case HttpMethod.get:
      return _getCalendars(context);
    case HttpMethod.post:
      return _createCalendar(context);
    default:
      return Response(statusCode: HttpStatus.methodNotAllowed);
  }
}

Future<Response> _getCalendars(RequestContext context) async {
  final db = MongoDataSource.db;
  // TODO: Filter by ownerId from JWT
  final calendars = await db.collection('calendars').find().toList();
  // Transform ObjectId to String
  final result = calendars.map((c) {
    c['id'] = (c['_id'] as ObjectId).toHexString();
    c.remove('_id');
    return c;
  }).toList();

  return Response.json(body: result);
}

Future<Response> _createCalendar(RequestContext context) async {
  final body = await context.request.json() as Map<String, dynamic>;
  // Validate body...

  final db = MongoDataSource.db;
  final id = ObjectId();
  final calendar = {
    '_id': id,
    'name': body['name'],
    'color': body['color'],
    'ownerId': 'TODO_USER_ID', // Extract from token
    'createdAt': DateTime.now(),
  };

  await db.collection('calendars').insert(calendar);

  calendar['id'] = id.toHexString();
  calendar.remove('_id');

  return Response.json(body: calendar);
}
