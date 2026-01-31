import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../presentation/core/providers.dart';
import 'auth_state.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(
    ref.watch(dioProvider),
    ref.watch(secureStorageProvider),
  );
});

final authNotifierProvider = StateNotifierProvider<AuthNotifier, AuthState>((
  ref,
) {
  return AuthNotifier(ref.watch(authRepositoryProvider));
});

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _repository;

  AuthNotifier(this._repository) : super(const AuthState.initial());

  Future<void> login(String email, String password) async {
    state = const AuthState.loading();
    final result = await _repository.login(email, password);
    state = result.fold(
      (l) => AuthState.failure(l),
      (r) => AuthState.authenticated(r),
    );
  }

  Future<void> register(String email, String password) async {
    state = const AuthState.loading();
    final result = await _repository.register(email, password);
    state = result.fold(
      (l) => AuthState.failure(l),
      (r) => AuthState.authenticated(r),
    );
  }

  Future<void> logout() async {
    await _repository.logout();
    state = const AuthState.unauthenticated();
  }

  Future<void> checkAuthStatus() async {
    // strict check
    final option = await _repository.getCurrentUser();
    state = option.fold(
      () => const AuthState.unauthenticated(),
      (user) => AuthState.authenticated(user),
    );
  }
}
