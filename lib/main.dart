import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:everglow_app/presentation/core/theme/app_theme.dart';
import 'package:everglow_app/presentation/core/router/app_router.dart';
import 'package:everglow_app/data/local/isar_provider.dart';

/// Entry point of the application
void main() async {
  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Create a ProviderContainer to preload the Isar database
  final container = ProviderContainer();

  // Preload the Isar database before running the app
  // This ensures the database is ready before any widget needs it
  await container.read(isarProvider.future);

  // Run the app wrapped in ProviderScope for Riverpod state management
  runApp(
    UncontrolledProviderScope(container: container, child: const MainApp()),
  );
}

/// Root widget of the application
class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      title: 'Everglow App',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme(),
      routerConfig: router,
    );
  }
}
