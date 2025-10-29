import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'dart:io' show Platform;
import 'package:quran_v3/app/quran_app.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();

  const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
  const initSettings = InitializationSettings(android: androidInit);
  await flutterLocalNotificationsPlugin.initialize(initSettings);

  const channel = AndroidNotificationChannel(
    'azan_channel_v2',
    'Azan Notifications',
    description: 'Pengingat waktu salat harian',
    importance: Importance.max,
    playSound: true,
    sound: RawResourceAndroidNotificationSound('azan_normal'),
  );

  final androidImpl =
      flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();

  await androidImpl?.createNotificationChannel(channel);

  if (Platform.isAndroid) {
    await androidImpl?.requestNotificationsPermission();
  }

  runApp(ModularApp(module: AppModule(), child: const QuranApp()));
}
