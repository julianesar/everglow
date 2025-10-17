import 'dart:math';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:timezone/timezone.dart' as tz;

/// Service responsible for managing local scheduled notifications
///
/// This service handles the scheduling of daily notifications including
/// midday check-ins and evening reflections for the user's journey.
class NotificationService {
  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  /// Initializes the notification service with platform-specific settings
  ///
  /// [router] The GoRouter instance used for navigation when notifications are tapped
  Future<void> init(GoRouter router) async {
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initializationSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _plugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        final payload = response.payload;
        if (payload != null) {
          router.go(payload);
        }
      },
    );

    // Request permissions for iOS
    await _plugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >()
        ?.requestPermissions(alert: true, badge: true, sound: true);

    // Request permissions for Android 13+
    await _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();
  }

  /// Schedules daily notifications for midday check-in and evening reflection
  ///
  /// Cancels any previously scheduled notifications and creates new ones
  /// with personalized content based on the user's priority.
  ///
  /// Uses inexact alarms (AndroidScheduleMode.inexactAllowWhileIdle) which
  /// don't require special permissions on Android 12+. Notifications may be
  /// delivered with a slight delay, but this avoids permission issues.
  ///
  /// [dayNumber] The current day number in the user's journey
  /// [priorityText] The user's declared priority to be included in the midday check-in
  Future<void> scheduleDailyNotifications({
    required int dayNumber,
    required String priorityText,
  }) async {
    // Cancel all previously scheduled notifications
    await _plugin.cancelAll();

    // Creative and inspiring midday check-in templates
    final List<String> middayTemplates = [
      "How's your {priority} going? Take a moment to check in with yourself and realign with what matters most.",
      "Midday pulse check: Are you still on track with {priority}? Small course corrections lead to big results.",
      "Remember {priority}? Now's the perfect time to assess your progress and adjust your sails.",
      "Your {priority} is calling. Pause, reflect, and ensure you're moving in the right direction today.",
    ];

    // Select a random template
    final random = Random();
    final selectedTemplate =
        middayTemplates[random.nextInt(middayTemplates.length)];

    // Replace placeholder with user's priority
    final middayBody = selectedTemplate.replaceAll('{priority}', priorityText);

    // Platform-specific notification details
    const androidDetails = AndroidNotificationDetails(
      'daily_reminders',
      'Daily Reminders',
      channelDescription: 'Daily check-in and reflection reminders',
      importance: Importance.high,
      priority: Priority.high,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    // Get current date and time
    final now = tz.TZDateTime.now(tz.local);

    // Schedule Midday Notification (1:00 PM)
    final middayTime = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      13, // 1:00 PM
      0,
    );

    // If midday time has passed today, schedule for tomorrow
    final scheduledMiddayTime = middayTime.isBefore(now)
        ? middayTime.add(const Duration(days: 1))
        : middayTime;

    await _plugin.zonedSchedule(
      0, // Notification ID for midday
      'Midday Check-in',
      middayBody,
      scheduledMiddayTime,
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      payload: '/day/$dayNumber',
    );

    // Schedule Evening Notification (8:00 PM)
    final eveningTime = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      20, // 8:00 PM
      0,
    );

    // If evening time has passed today, schedule for tomorrow
    final scheduledEveningTime = eveningTime.isBefore(now)
        ? eveningTime.add(const Duration(days: 1))
        : eveningTime;

    await _plugin.zonedSchedule(
      1, // Notification ID for evening
      'Evening Reflection',
      "Time to lock in today's release. Open your journal to reflect on your journey.",
      scheduledEveningTime,
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      payload: '/day/$dayNumber',
    );
  }
}

/// Provider for the NotificationService
///
/// Use this provider to access the notification service throughout the app.
final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationService();
});
