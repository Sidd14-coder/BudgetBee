import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz_all;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import '../globals.dart';
import 'dream_service.dart';
import 'dart:math';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    tz_all.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Kolkata')); // Set timezone to IST
    
    // Default Android icon (usually @mipmap/ic_launcher)
    const AndroidInitializationSettings androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings iosSettings = DarwinInitializationSettings();
    
    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _flutterLocalNotificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (response) {
        // Handle clicking the notification (optional)
      },
    );

    // Schedule smart contextual reminders
    scheduleSmartReminders();
  }

  // Best practice: Request permission AFTER UI is fully built
  Future<void> requestPermission() async {
    if (await Permission.notification.isDenied) {
      await Permission.notification.request();
    }
  }

  Future<void> scheduleSmartReminders() async {
    // Clear old recurring smart reminders (IDs 100 to 103)
    for (int i = 100; i < 104; i++) {
      await _flutterLocalNotificationsPlugin.cancel(i);
    }

    // Determine current financial context
    final double difference = totalDebit - totalCredit;
    final bool isOverspending = difference > 0;
    final dreams = DreamService.getAllDreams();
    
    // Create contextual messages
    List<String> messages = [];
    if (isOverspending) {
      messages.add("⚠️ You are overspending by ₹${difference.abs().toStringAsFixed(0)}! Time to cut back?");
      messages.add("💡 Avoid unnecessary expenses today, you've crossed your income limit.");
    } else {
      messages.add("💸 Great job! Your spending is well under control.");
      messages.add("💰 You have ₹${difference.abs().toStringAsFixed(0)} saved up! Consider investing it.");
    }

    if (dreams.isNotEmpty) {
      final active = dreams.first;
      messages.add("🎯 Stay focused on '${active.name}'! Every saved rupee brings you closer.");
      messages.add("🚀 Skip the junk food today -> Add to your '${active.name}' fund!");
    } else {
      messages.add("🎯 Have you set a Dream Goal yet? Budgeting is more fun when you save for a reward!");
    }

    // Add generic motivation
    messages.add("📊 Don't forget to review your weekly spending analytics.");
    messages.add("💳 Check your credit card usage to avoid hidden charges.");

    // Shuffle and pick 4 unique messages
    messages.shuffle(Random());
    final List<String> selectedMessages = messages.take(4).toList();

    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'smart_reminders_channel',
      'Smart Reminders',
      channelDescription: 'Contextual notifications about your budget and goals.',
      importance: Importance.max,
      priority: Priority.high,
      color: Color(0xFF0A3622),
    );
    const NotificationDetails notificationDetails = NotificationDetails(android: androidDetails);

    // Schedule for 9 AM, 1 PM, 5 PM, 9 PM
    final scheduleHours = [9, 13, 17, 21];
    
    for (int i = 0; i < 4; i++) {
        final now = tz.TZDateTime.now(tz.local);
        var scheduledDate = tz.TZDateTime(tz.local, now.year, now.month, now.day, scheduleHours[i], 0, 0);
        
        // If hour has passed today, schedule for tomorrow
        if (scheduledDate.isBefore(now)) {
          scheduledDate = scheduledDate.add(const Duration(days: 1));
        }

        await _flutterLocalNotificationsPlugin.zonedSchedule(
          100 + i, // ID
          'BudgetBee Insights 🐝',
          selectedMessages[i],
          scheduledDate,
          notificationDetails,
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
          uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
          matchDateTimeComponents: DateTimeComponents.time, // Repeats daily
        );
    }
  }

  static Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
  }) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'emi_reminder_channel',
      'EMI Reminders',
      channelDescription: 'Reminds you of your upcoming EMIs',
      importance: Importance.max,
      priority: Priority.high,
      color: Color(0xFF0A3622),
    );

    const NotificationDetails notificationDetails = NotificationDetails(android: androidDetails);

    tz.TZDateTime scheduledTZDate = tz.TZDateTime.from(scheduledDate, tz.local);
    
    // Safety check: if date is in the past, don't schedule or it will crash.
    // For testing/fallback, we'll schedule it 5 seconds from now if the date is in the past.
    if (scheduledTZDate.isBefore(tz.TZDateTime.now(tz.local))) {
      scheduledTZDate = tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5));
    }

    await _instance._flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      scheduledTZDate,
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
    );
  }
}
