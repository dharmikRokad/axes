import 'dart:io';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

class TokenService {
  String get _secret => Platform.environment['JWT_SECRET'] ?? 'default_secret';

  String generateAccessToken(String userId) {
    final jwt = JWT({'uid': userId});
    // Expire in 15 minutes
    return jwt.sign(SecretKey(_secret), expiresIn: const Duration(minutes: 15));
  }

  String generateRefreshToken(String userId) {
    final jwt = JWT({'uid': userId, 'type': 'refresh'});
    // Expire in 7 days
    return jwt.sign(SecretKey(_secret), expiresIn: const Duration(days: 7));
  }

  JWT? verify(String token) {
    try {
      return JWT.verify(token, SecretKey(_secret));
    } catch (_) {
      return null;
    }
  }
}
