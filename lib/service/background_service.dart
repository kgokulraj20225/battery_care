//
// import 'dart:async';
// import 'dart:ui';
// import 'package:battery_plus/battery_plus.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_background_service/flutter_background_service.dart';
// import 'package:flutter_background_service_android/flutter_background_service_android.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:get/get.dart';
// import 'package:just_audio/just_audio.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// final FlutterLocalNotificationsPlugin notificationsPlugin =
// FlutterLocalNotificationsPlugin();
// final battery = Battery();
//
// // Initialize background service
// Future<void> initializeService() async {
//   final service = FlutterBackgroundService();
//
//   const AndroidNotificationChannel channel = AndroidNotificationChannel(
//     'battery_alarm_channel',
//     'Battery Alarm Service',
//     description: 'Triggers alarm when selected battery level is reached',
//     importance: Importance.max,
//     playSound: false,
//   );
//
//   final androidPlugin = notificationsPlugin
//       .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
//   await androidPlugin?.createNotificationChannel(channel);
//   await androidPlugin?.requestNotificationsPermission();
//
//   await service.configure(
//     androidConfiguration: AndroidConfiguration(
//       onStart: onStart,
//       isForegroundMode: true,
//       notificationChannelId: 'battery_alarm_channel',
//       initialNotificationTitle: 'Battery Alarm Active',
//       initialNotificationContent: 'Monitoring battery level...',
//       foregroundServiceNotificationId: 999,
//     ),
//     iosConfiguration: IosConfiguration(
//       autoStart: true,
//       onForeground: onStart,
//       onBackground: (_) => true,
//     ),
//   );
//
//   await service.startService();
// }
//
// @pragma('vm:entry-point')
// void onStart(ServiceInstance service) async {
//   DartPluginRegistrant.ensureInitialized();
//
//   final AudioPlayer player = AudioPlayer();
//   final SharedPreferences prefs = await SharedPreferences.getInstance();
//
//   // Read user-selected values
//   int selectedUserValue = prefs.getInt('user_picker_value') ?? 0;
//   String selectedUserSongPath = prefs.getString('selected_song_path') ?? '';
//   bool alarmOnOff = prefs.getBool('alarm_switch_on_off') ?? false;
//
//   DateTime? lastAlarmTime;
//   const cooldownDuration = Duration(minutes: 1);
//
//   // Initialize notification plugin
//   final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//   FlutterLocalNotificationsPlugin();
//   await flutterLocalNotificationsPlugin.initialize(
//     const InitializationSettings(
//       android: AndroidInitializationSettings('@mipmap/ic_launcher'),
//     ),
//     onDidReceiveNotificationResponse: (NotificationResponse response) async {
//       if (response.actionId == 'stop_alarm' || response.payload == 'stop_alarm') {
//         await stopAlarm(player, prefs, flutterLocalNotificationsPlugin);
//       }
//     },
//   );
//
//   // Set foreground notification for the service
//   if (service is AndroidServiceInstance) {
//     service.setForegroundNotificationInfo(
//       title: 'Battery Alarm Active',
//       content: '$selectedUserValue battery level set to alarm...',
//     );
//   }
//
//   // Listen for battery state changes
//   StreamSubscription<BatteryState>? batteryStateSubscription;
//   batteryStateSubscription = battery.onBatteryStateChanged.listen((BatteryState state) async {
//     int level = await battery.batteryLevel;
//     print("Battery: $level%, target: $selectedUserValue, alarmOn: $alarmOnOff");
//
//     if (level == selectedUserValue && alarmOnOff) {
//       if (lastAlarmTime == null || DateTime.now().difference(lastAlarmTime!) > cooldownDuration) {
//         print("Battery threshold reached, playing alarm");
//         await playAlarm(flutterLocalNotificationsPlugin, player, prefs, selectedUserSongPath);
//         lastAlarmTime = DateTime.now();
//       }
//     }
//   });
//
//   // Listen for service commands
//   service.on('stopAlarm').listen((event) async {
//     await stopAlarm(player, prefs, flutterLocalNotificationsPlugin);
//   });
//
//   service.on('stopService').listen((event) async {
//     await stopAlarm(player, prefs, flutterLocalNotificationsPlugin);
//     batteryStateSubscription?.cancel();
//     service.stopSelf();
//   });
// }
//
// // Play alarm with notification
// Future<void> playAlarm(
//     FlutterLocalNotificationsPlugin plugin,
//     AudioPlayer player,
//     SharedPreferences prefs,
//     String songPath,
//     ) async {
//   if (prefs.getBool('is_alarm_active') ?? false) {
//     print("Alarm already active, skipping");
//     return;
//   }
//
//   if (songPath.isEmpty) {
//     print("No song path set for alarm");
//     return;
//   }
//
//   try {
//     await prefs.setBool('is_alarm_active', true);
//
//     if (player.playing) {
//       await player.stop();
//     }
//
//     await player.setFilePath(songPath);
//     await player.setLoopMode(LoopMode.one);
//     await player.play();
//
//     await plugin.show(
//       999,
//       'Battery Level Reached',
//       'Tap to stop alarm',
//       NotificationDetails(
//         android: AndroidNotificationDetails(
//           'battery_alarm_channel',
//           'Battery Alarm',
//           importance: Importance.max,
//           priority: Priority.high,
//           playSound: false,
//           actions: [
//             AndroidNotificationAction(
//               'stop_alarm',
//               'Stop Alarm',
//               showsUserInterface: false,
//               cancelNotification: true,
//             ),
//           ],
//         ),
//       ),
//       payload: 'stop_alarm',
//     );
//     print("Alarm playing and notification shown");
//   } catch (e) {
//     print("Error playing alarm: $e");
//     await prefs.setBool('is_alarm_active', false);
//   }
// }
//
// // Stop alarm and cancel notification
// Future<void> stopAlarm(AudioPlayer player, SharedPreferences prefs,
//     FlutterLocalNotificationsPlugin plugin) async {
//   if (player.playing) {
//     await player.stop();
//     await player.setLoopMode(LoopMode.off);
//   }
//   await prefs.setBool('is_alarm_active', false);
//   await plugin.cancel(999);
//   print("Alarm stopped");
// }

import 'dart:async';
import 'dart:ui';
import 'package:battery_plus/battery_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';

final FlutterLocalNotificationsPlugin notificationsPlugin =
FlutterLocalNotificationsPlugin();
final battery = Battery();

// Initialize background service
Future<void> initializeService() async {
  final service = FlutterBackgroundService();

  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'battery_alarm_channel',
    'Battery Alarm Service',
    description: 'Triggers alarm when selected battery level is reached',
    importance: Importance.max,
    playSound: false,
  );

  final androidPlugin = notificationsPlugin
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
  await androidPlugin?.createNotificationChannel(channel);
  await androidPlugin?.requestNotificationsPermission();

  await service.configure(
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      isForegroundMode: true,
      notificationChannelId: 'battery_alarm_channel',
      initialNotificationTitle: 'Battery Alarm Active',
      initialNotificationContent: 'Monitoring battery level...',
      foregroundServiceNotificationId: 999,
    ),
    iosConfiguration: IosConfiguration(
      autoStart: true,
      onForeground: onStart,
      onBackground: (_) => true,
    ),
  );

  await service.startService();
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  DartPluginRegistrant.ensureInitialized();

  final AudioPlayer player = AudioPlayer();
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  // Read user-selected values
  int selectedUserValue = prefs.getInt('user_picker_value') ?? 0;
  String selectedUserSongPath = prefs.getString('selected_song_path') ?? '';
  bool alarmOnOff = prefs.getBool('alarm_switch_on_off') ?? false;

  DateTime? lastAlarmTime;
  const cooldownDuration = Duration(minutes: 1);

  // Initialize notification plugin
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
  await flutterLocalNotificationsPlugin.initialize(
    const InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
    ),
    onDidReceiveNotificationResponse: (NotificationResponse response) async {
      if (response.actionId == 'stop_alarm' || response.payload == 'stop_alarm') {
        await stopAlarm(player, prefs, flutterLocalNotificationsPlugin);
      }
    },
  );

  // Set foreground notification for the service
  if (service is AndroidServiceInstance) {
    service.setForegroundNotificationInfo(
      title: 'Battery Alarm Active',
      content: '$selectedUserValue battery level set to alarm...',
    );
  }

  // Listen for battery state changes
  StreamSubscription<BatteryState>? batteryStateSubscription;
  batteryStateSubscription = battery.onBatteryStateChanged.listen((BatteryState state) async {
    int level = await battery.batteryLevel;
    print("Battery: $level%, target: $selectedUserValue, alarmOn: $alarmOnOff");

    if (level == selectedUserValue && alarmOnOff) {
      if (lastAlarmTime == null || DateTime.now().difference(lastAlarmTime!) > cooldownDuration) {
        print("Battery threshold reached, playing alarm");
        await playAlarm(flutterLocalNotificationsPlugin, player, prefs, selectedUserSongPath);
        lastAlarmTime = DateTime.now();
      }
    }
  });

  // Listen for service commands
  service.on('stopAlarm').listen((event) async {
    await stopAlarm(player, prefs, flutterLocalNotificationsPlugin);
  });

  service.on('stopService').listen((event) async {
    await stopAlarm(player, prefs, flutterLocalNotificationsPlugin);
    batteryStateSubscription?.cancel();
    service.stopSelf();
  });
}

// Play alarm with notification
Future<void> playAlarm(
    FlutterLocalNotificationsPlugin plugin,
    AudioPlayer player,
    SharedPreferences prefs,
    String songPath,
    ) async {
  if (prefs.getBool('is_alarm_active') ?? false) {
    print("Alarm already active, skipping");
    return;
  }

  if (songPath.isEmpty) {
    print("No song path set for alarm");
    return;
  }

  try {
    await prefs.setBool('is_alarm_active', true);

    if (player.playing) {
      await player.stop();
    }

    await player.setFilePath(songPath);
    await player.setLoopMode(LoopMode.one);
    await player.play();

    await plugin.show(
      999,
      'Battery Level Reached',
      'Tap to stop alarm',
      NotificationDetails(
        android: AndroidNotificationDetails(
          'battery_alarm_channel',
          'Battery Alarm',
          importance: Importance.max,
          priority: Priority.high,

          playSound: false,
          actions: [
            AndroidNotificationAction(
              'stop_alarm',
              'Stop Alarm',
              showsUserInterface: false,
              cancelNotification: true,
            ),
          ],
        ),
      ),
      payload: 'stop_alarm',
    );
    print("Alarm playing and notification shown");
  } catch (e) {
    print("Error playing alarm: $e");
    await prefs.setBool('is_alarm_active', false);
  }
}

// Stop alarm and cancel notification
Future<void> stopAlarm(AudioPlayer player, SharedPreferences prefs,
    FlutterLocalNotificationsPlugin plugin) async {
  if (player.playing) {
    await player.stop();
    await player.setLoopMode(LoopMode.off);
  }
  await prefs.setBool('is_alarm_active', false);
  await plugin.cancel(999);
  print("Alarm stopped");
}
