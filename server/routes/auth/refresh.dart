import 'dart:async';
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import '../../lib/services/token_service.dart';

Future<Response> onRequest(RequestContext context) async {
  if (context.request.method != HttpMethod.post) {
    return Response(statusCode: HttpStatus.methodNotAllowed);
  }

  final body = await context.request.json() as Map<String, dynamic>;
  final refreshToken = body['refreshToken'] as String?;

  if (refreshToken == null) {
    return Response.json(
      statusCode: HttpStatus.badRequest,
      body: {'error': 'Refresh token required'},
    );
  }

  final tokenService = context.read<TokenService>();
  final payload = tokenService.verify(refreshToken);

  if (payload == null || payload.payload['type'] != 'refresh') {
    return Response.json(
      statusCode: HttpStatus.unauthorized,
      body: {'error': 'Invalid refresh token'},
    );
  }

  final userId = payload.payload['uid'] as String;
  final newAccessToken = tokenService.generateAccessToken(userId);
  // Optional: Rotate refresh token

  return Response.json(body: {
    'accessToken': newAccessToken,
  });
}
