import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'presentation/routes/app_router.dart';
import 'presentation/core/app_theme.dart';
import 'application/theme/theme_notifier.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: AxesApp()));
}

class AxesApp extends ConsumerWidget {
  const AxesApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final themeAsync = ref.watch(themeModeNotifierProvider);

    return MaterialApp.router(
      title: 'Axes Calendar',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeAsync.when(
        data: (mode) => mode,
        loading: () => ThemeMode.system,
        error: (_, __) => ThemeMode.system,
      ),
      debugShowCheckedModeBanner: false,
      routerConfig: router,
    );
  }
}
