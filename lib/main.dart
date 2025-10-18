import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:everglow_app/core/theme/app_theme.dart';
import 'package:everglow_app/core/router/app_router.dart';
import 'package:everglow_app/core/database/isar_provider.dart';
import 'package:everglow_app/core/services/notification_service.dart';
import 'package:everglow_app/core/secrets/supabase_keys.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

/// Entry point of the application
void main() async {
  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase client
  try {
    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseAnonKey,
    );
  } catch (e) {
    // Log the error and rethrow to prevent app from running with uninitialized Supabase
    debugPrint('Failed to initialize Supabase: $e');
    rethrow;
  }

  // Initialize timezone database
  // This MUST be called before using any timezone functionality
  tz.initializeTimeZones();
  // Set the local location to UTC as a fallback
  // In production, you might want to use flutter_native_timezone to get the device's timezone
  // For now, we use UTC to ensure consistent behavior across devices
  tz.setLocalLocation(tz.UTC);

  // Create a ProviderContainer to preload the Isar database
  final container = ProviderContainer();

  // Preload the Isar database before running the app
  // This ensures the database is ready before any widget needs it
  await container.read(isarProvider.future);

  // Initialize notification service
  final notificationService = container.read(notificationServiceProvider);
  final router = container.read(appRouterProvider);
  await notificationService.init(router);

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
