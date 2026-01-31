import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final Dio _dio;
  final FlutterSecureStorage _storage;
    
  AuthRepositoryImpl(this._dio, this._storage);

  @override
  Future<Either<String, User>> login(String email, String password) async {
    try {
      final response = await _dio.post(
        '/auth/login',
        data: {'email': email, 'password': password},
      );

      final data = response.data;
      final user = User.fromJson(data['user']);
      await _storage.write(key: 'accessToken', value: data['accessToken']);
      await _storage.write(key: 'refreshToken', value: data['refreshToken']);

      return right(user);
    } on DioException catch (e) {
      print('erorr $e');
      if (e.response?.data != null && e.response!.data['error'] != null) {
        return left(e.response!.data['error']);
      }
      return left('Login failed');
    } catch (e, s) {
      print('erorr $e $s');
      return left(e.toString());
    }
  }

  @override
  Future<Either<String, User>> register(String email, String password) async {
    try {
      final response = await _dio.post(
        '/auth/register',
        data: {'email': email, 'password': password},
      );

      final data = response.data;
      final user = User.fromJson(data['user']);
      await _storage.write(key: 'accessToken', value: data['accessToken']);
      await _storage.write(key: 'refreshToken', value: data['refreshToken']);

      return right(user);
    } on DioException catch (e) {
      if (e.response?.data != null && e.response!.data['error'] != null) {
        return left(e.response!.data['error']);
      }
      return left('Registration failed');
    } catch (e) {
      return left(e.toString());
    }
  }

  @override
  Future<void> logout() async {
    await _storage.delete(key: 'accessToken');
    await _storage.delete(key: 'refreshToken');
  }

  @override
  Future<Option<User>> getCurrentUser() async {
    // TODO: Implement /auth/me or verify token and decode
    // For now, simpler implementation:
    // If token exists, we might need to fetch profile.
    // Let's assume we store user info locally or fetch it.
    // For this MVP step, we will return none() if not fully implemented.
    return none();
  }
}
