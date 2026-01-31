import 'dart:async';
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import '../../lib/repositories/user_repository.dart';
import '../../lib/services/password_service.dart';
import '../../lib/services/token_service.dart';

Future<Response> onRequest(RequestContext context) async {
  if (context.request.method != HttpMethod.post) {
    return Response(statusCode: HttpStatus.methodNotAllowed);
  }

  final body = await context.request.json() as Map<String, dynamic>;
  final email = body['email'] as String?;
  final password = body['password'] as String?;

  if (email == null || password == null) {
    return Response.json(
      statusCode: HttpStatus.badRequest,
      body: {'error': 'Email and password required'},
    );
  }

  final userRepo = context.read<UserRepository>();
  final passwordService = context.read<PasswordService>();
  final tokenService = context.read<TokenService>();

  final existingUser = await userRepo.findByEmail(email);
  if (existingUser != null) {
    return Response.json(
      statusCode: HttpStatus.conflict,
      body: {'error': 'User already exists'},
    );
  }

  final hashedPassword = passwordService.hashPassword(password);
  final user = await userRepo.createUser(
    email: email,
    passwordHash: hashedPassword,
  );

  final accessToken = tokenService.generateAccessToken(user.id);
  final refreshToken = tokenService.generateRefreshToken(user.id);

  return Response.json(body: {
    'user': user.toJson(),
    'accessToken': accessToken,
    'refreshToken': refreshToken,
  });
}
