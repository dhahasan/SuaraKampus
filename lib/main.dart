import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/database/app_database.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    // Initialize SQLite database
    await AppDatabase.instance.init();
  } catch (e, stack) {
    debugPrint('Database initialization notice: $e\n$stack');
  }

  runApp(
    const ProviderScope(
      child: SuaraKampusApp(),
    ),
  );
}

class SuaraKampusApp extends ConsumerWidget {
  const SuaraKampusApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      title: 'SuaraKampus',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routerConfig: router,
    );
  }
}
