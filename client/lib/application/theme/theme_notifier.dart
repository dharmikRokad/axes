import 'package:flutter/material.dart';
import '../../presentation/core/providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'theme_notifier.g.dart';

@riverpod
class ThemeModeNotifier extends _$ThemeModeNotifier {
  static const _storageKey = 'theme_mode';

  @override
  FutureOr<ThemeMode> build() async {
    final storage = ref.read(secureStorageProvider);
    final savedTheme = await storage.read(key: _storageKey);

    if (savedTheme == 'light') return ThemeMode.light;
    if (savedTheme == 'dark') return ThemeMode.dark;
    return ThemeMode.system;
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    final storage = ref.read(secureStorageProvider);
    await storage.write(key: _storageKey, value: mode.name);
    state = AsyncData(mode);
  }
}
