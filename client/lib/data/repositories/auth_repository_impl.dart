import 'dart:convert';
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
      await _storage.write(key: 'user', value: jsonEncode(user.toJson()));

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
      await _storage.write(key: 'user', value: jsonEncode(user.toJson()));

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
    await _storage.delete(key: 'user');
  }

  @override
  Future<Option<User>> getCurrentUser() async {
    final userJson = await _storage.read(key: 'user');
    final accessToken = await _storage.read(key: 'accessToken');

    if (userJson != null && accessToken != null) {
      try {
        final user = User.fromJson(jsonDecode(userJson));
        return some(user);
      } catch (_) {
        return none();
      }
    }
    return none();
  }
}
