// import 'dart:async';
// import 'dart:ui';
// import 'package:battery_plus/battery_plus.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_background_service/flutter_background_service.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:get/get.dart';
// import 'package:just_audio/just_audio.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:trial_app/battery_info_pages/controller_battery/song_picker_controller.dart';
//
// final FlutterLocalNotificationsPlugin notificationsPlugin = FlutterLocalNotificationsPlugin();
// final battery = Battery();
//
// // initialized background service
//
// Future initializedService() async {
//   final service = FlutterBackgroundService();
//   const AndroidNotificationChannel channel = AndroidNotificationChannel(
//     'battery_alarm_channel',
//     'Battery Alarm Service',
//     description: 'Triggers alarm when selected battery level is reached',
//     importance: Importance.max,
//   );
//
//   await notificationsPlugin
//       .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
//       ?.createNotificationChannel(channel);
//
//   await service.configure(
//     androidConfiguration: AndroidConfiguration(
//       onStart: onStart,
//       isForegroundMode: true,
//       notificationChannelId: 'battery_alarm_channel',
//       initialNotificationTitle: 'Battery Alarm Active',
//       initialNotificationContent: 'Monitoring battery level...',
//     ),
//     iosConfiguration: IosConfiguration(),
//   );
//   service.startService();
// }
//
// /// 🔹 Background entry point (runs continuously)
//
//
//
// @pragma('vm:entry-point')
// void onStart(ServiceInstance service) async {
//   // Ensure Dart executor is initialized for background isolate
//   DartPluginRegistrant.ensureInitialized();
//
//   final AudioPlayer player = AudioPlayer();
//   final SharedPreferences prefs = await SharedPreferences.getInstance();
//   final int selectedUserValue = prefs.getInt('user_picker_value') ?? 0;
//   final String selectedUserSongPath = prefs.getString('selected_song_path') ?? '';
//   final bool alarmOnOff = prefs.getBool('alarm_switch_on_off') ?? false;
//
//   // Define the notification channel for Android
//   const AndroidNotificationChannel channel = AndroidNotificationChannel(
//     'battery_alarm_channel',
//     'Battery Alarm Service',
//     description: 'Triggers alarm when selected battery level is reached',
//     importance: Importance.max,
//     playSound: false, // Avoid default notification sound, as we play a custom alarm
//   );
//
//   // Initialize FlutterLocalNotificationsPlugin
//   final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//   FlutterLocalNotificationsPlugin();
//   await flutterLocalNotificationsPlugin.initialize(
//     const InitializationSettings(
//       android: AndroidInitializationSettings('@mipmap/ic_launcher'),
//     ),
//     onDidReceiveNotificationResponse: (NotificationResponse response) async {
//       if (response.actionId == 'stop_alarm') {
//         await player.stop();
//         await player.setLoopMode(LoopMode.off);
//         await prefs.setBool('is_alarm_active', false);
//         print('Alarm stopped via notification action');
//         // Cancel the alarm notification
//         await flutterLocalNotificationsPlugin.cancel(888);
//       }
//     },
//   );
//
//   // Create the notification channel
//   await flutterLocalNotificationsPlugin
//       .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
//       ?.createNotificationChannel(channel);
//
//   // Request notification permission (Android 13+)
//   await flutterLocalNotificationsPlugin
//       .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
//       ?.requestPermission();
//
//   // Set the service as a foreground service
//   if (service is AndroidServiceInstance) {
//     service.setForegroundNotificationInfo(
//       title: 'Battery Alarm Active',
//       content: 'Monitoring battery level...',
//     );
//   }
//
//   // Periodic task to check battery level
//   Timer.periodic(const Duration(seconds: 15), (timer) async {
//     int level = await battery.batteryLevel;
//     if (level == selectedUserValue && alarmOnOff) {
//       print('Battery level $level reached, playing alarm');
//       await playAlarm(flutterLocalNotificationsPlugin, player, selectedUserSongPath);
//     }
//   });
//
//   // Listen for stop alarm event
//   service.on('stopAlarm').listen((event) async {
//     await player.stop();
//     await player.setLoopMode(LoopMode.off);
//     await prefs.setBool('is_alarm_active', false);
//     await flutterLocalNotificationsPlugin.cancel(888);
//     print('Alarm manually stopped');
//   });
//
//   // Listen for stop service event
//   service.on('stopService').listen((event) async {
//     await player.stop();
//     await prefs.setBool('is_alarm_active', false);
//     await flutterLocalNotificationsPlugin.cancelAll();
//     print('Background service stopped');
//     service.stopSelf();
//   });
// }
//
//
//
//
// ///
// Future<void> playAlarm(FlutterLocalNotificationsPlugin plugin,AudioPlayer player,String songpath) async {
//   try {
//     await player.setFilePath(songpath);
//
//     await player.play();
//     await player.setLoopMode(LoopMode.one);
//     await plugin.show(
//         999,
//         'Battery Level Reached',
//         'Tap to stop alarm',
//         const NotificationDetails(
//             android: AndroidNotificationDetails(
//                 'battery_alarm_channel', 'Battery Alarm',
//                 importance: Importance.max,
//                 priority: Priority.high,
//                 playSound: false,
//                 actions: <AndroidNotificationAction>[
//                   AndroidNotificationAction('stop_alarm', 'Stop Alarm',
//                       showsUserInterface: true
//                   )
//                 ]
//             )
//         ),
//         payload: 'stop_alarm');
//   }catch(e){
//     print('Error playing alarm: $e');
//   }
// }


// // another code
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
// final FlutterLocalNotificationsPlugin notificationsPlugin = FlutterLocalNotificationsPlugin();
// final battery = Battery();
//
// // Initialize background service
// Future<void> initializeService() async {
//   final service = FlutterBackgroundService();
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
//   await service.startService();
// }
//
//
// @pragma('vm:entry-point')
// void onStart(ServiceInstance service) async {
//   // Ensure Dart executor is initialized for background isolate
//   DartPluginRegistrant.ensureInitialized();
//
//   final AudioPlayer player = AudioPlayer();
//   final SharedPreferences prefs = await SharedPreferences.getInstance();
//   final int selectedUserValue = prefs.getInt('user_picker_value') ?? 0;
//   final String selectedUserSongPath = prefs.getString('selected_song_path') ?? '';
//   final bool alarmOnOff = prefs.getBool('alarm_switch_on_off') ?? false;
//
//   // Define the notification channel for Android
//   const AndroidNotificationChannel channel = AndroidNotificationChannel(
//     'battery_alarm_channel',
//     'Battery Alarm Service',
//     description: 'Triggers alarm when selected battery level is reached',
//     importance: Importance.max,
//   );
//
//   // Initialize FlutterLocalNotificationsPlugin
//   final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//   FlutterLocalNotificationsPlugin();
//   await flutterLocalNotificationsPlugin.initialize(
//     const InitializationSettings(
//       android: AndroidInitializationSettings('@mipmap/ic_launcher'),
//     ),
//     onDidReceiveNotificationResponse: (NotificationResponse response) async {
//       await player.stop();
//       await player.setLoopMode(LoopMode.off);
//       print('Notification tapped, alarm stopped');
//     },
//   );
//
//   // Create the notification channel
//   await flutterLocalNotificationsPlugin
//       .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
//       ?.createNotificationChannel(channel);
//
//   // Set the service as a foreground service
//   if (service is AndroidServiceInstance) {
//     service.setForegroundNotificationInfo(
//       title: 'Battery Alarm Active',
//       content: 'Monitoring battery level...',
//     );
//   }
//
//   // Periodic task to check battery level
//   Timer.periodic(const Duration(seconds: 15), (timer) async {
//     int level = await battery.batteryLevel;
//     if (level == selectedUserValue && alarmOnOff) {
//       print('Battery level $level reached, playing alarm');
//       await playAlarm(flutterLocalNotificationsPlugin, player, selectedUserSongPath);
//     }
//   });
//
//   // Listen for stop alarm event
//   service.on('stopAlarm').listen((event) async {
//     await player.stop();
//     print('Alarm manually stopped');
//   });
//
//   // Listen for stop service event
//   service.on('stopService').listen((event) async {
//     await player.stop();
//     print('Background service stopped');
//     service.stopSelf();
//   });
// }
//
// Future<void> playAlarm(
//     FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
//     AudioPlayer player,
//     String songPath,
//     ) async {
//   final SharedPreferences prefs = await SharedPreferences.getInstance();
//   final bool isAlarmActive = prefs.getBool('is_alarm_active') ?? false;
//
//   if (isAlarmActive) {
//     print("Alarm already active, skipping");
//     return;
//   }
//
//   if (songPath.isEmpty) {
//     print("No valid song path for alarm");
//     return;
//   }
//
//   try {
//     await prefs.setBool('is_alarm_active', true);
//     if (player.playing) {
//       print("Stopping current alarm playback");
//       await player.stop();
//     }
//     await player.seek(Duration.zero);
//     print("Setting alarm file path: $songPath");
//     await player.setFilePath(songPath);
//     await player.setLoopMode(LoopMode.one);
//     await player.play();
//
//     // Show notification with a "Stop" action
//     await flutterLocalNotificationsPlugin.show(
//       888,
//       'Battery Alarm',
//       'Battery level reached, alarm playing',
//       NotificationDetails(
//         android: AndroidNotificationDetails(
//           'battery_alarm_channel',
//           'Battery Alarm Service',
//           importance: Importance.max,
//           priority: Priority.high,
//           ongoing: true,
//           actions: [
//             AndroidNotificationAction(
//               'stop_alarm',
//               'Stop Alarm',
//               showsUserInterface: false,
//               cancelNotification: false, // Keep notification until explicitly canceled
//             ),
//           ],
//         ),
//       ),
//     );
//
//     // Monitor song completion
//     player.playerStateStream.listen((state) {
//       if (state.processingState == ProcessingState.completed) {
//         print("Alarm song completed, looping due to LoopMode.one");
//       }
//     });
//   } catch (e) {
//     print("Error playing alarm: $e");
//     await prefs.setBool('is_alarm_active', false);
//   }
// }


// grok code
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
// final FlutterLocalNotificationsPlugin notificationsPlugin = FlutterLocalNotificationsPlugin();
// final battery = Battery();
//
// // Initialize background service
// Future<void> initializeService() async {
//   final service = FlutterBackgroundService();
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
//   await service.startService();
// }
//
// @pragma('vm:entry-point')
// void onStart(ServiceInstance service) async {
//   DartPluginRegistrant.ensureInitialized();
//
//   final AudioPlayer player = AudioPlayer();
//   final SharedPreferences prefs = await SharedPreferences.getInstance();
//   final int selectedUserValue = prefs.getInt('user_picker_value') ?? 0;
//   final String selectedUserSongPath = prefs.getString('selected_song_path') ?? '';
//   final bool alarmOnOff = prefs.getBool('alarm_switch_on_off') ?? false;
//   DateTime? lastAlarmTime;
//   const cooldownDuration = Duration(minutes: 1);
//
//   const AndroidNotificationChannel channel = AndroidNotificationChannel(
//     'battery_alarm_channel',
//     'Battery Alarm Service',
//     description: 'Triggers alarm when selected battery level is reached',
//     importance: Importance.max,
//     playSound: false,
//   );
//
//   final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//   FlutterLocalNotificationsPlugin();
//   await flutterLocalNotificationsPlugin.initialize(
//     const InitializationSettings(
//       android: AndroidInitializationSettings('@mipmap/ic_launcher'),
//     ),
//     onDidReceiveNotificationResponse: (NotificationResponse response) async {
//       print('Notification response received: ${response.actionId}, payload: ${response.payload}');
//       if (response.actionId == 'stop_alarm' || response.payload == 'stop_alarm') {
//         await player.stop();
//         await player.setLoopMode(LoopMode.off);
//         await prefs.setBool('is_alarm_active', false);
//         print('Alarm stopped via notification action');
//         await flutterLocalNotificationsPlugin.cancel(888);
//       }
//     },
//   );
//
//   await flutterLocalNotificationsPlugin
//       .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
//       ?.createNotificationChannel(channel);
//
//   // Request notification permission
//   final androidPlugin = flutterLocalNotificationsPlugin
//       .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
//   if (androidPlugin != null) {
//     final granted = await androidPlugin.requestNotificationsPermission();
//     print('Notification permission granted: $granted');
//   }
//
//   if (service is AndroidServiceInstance) {
//     service.setForegroundNotificationInfo(
//       title: 'Battery Alarm Active',
//       content: 'Monitoring battery level...',
//     );
//   }
//
//   // Battery state change listener with cooldown
//   StreamSubscription<BatteryState>? batteryStateSubscription;
//   batteryStateSubscription = battery.onBatteryStateChanged.listen((BatteryState state) async {
//     int level = await battery.batteryLevel;
//     if (level == selectedUserValue && alarmOnOff) {
//       if (lastAlarmTime == null || DateTime.now().difference(lastAlarmTime!) > cooldownDuration) {
//         print('Battery level $level reached, playing alarm');
//         await playAlarm(flutterLocalNotificationsPlugin, player, selectedUserSongPath);
//         lastAlarmTime = DateTime.now();
//       }
//     }
//   });
//
//   service.on('stopAlarm').listen((event) async {
//     await player.stop();
//     await player.setLoopMode(LoopMode.off);
//     await prefs.setBool('is_alarm_active', false);
//     await flutterLocalNotificationsPlugin.cancel(888);
//     print('Alarm manually stopped');
//   });
//
//   service.on('stopService').listen((event) async {
//     await player.stop();
//     await prefs.setBool('is_alarm_active', false);
//     await flutterLocalNotificationsPlugin.cancelAll();
//     batteryStateSubscription?.cancel();
//     print('Background service stopped');
//     service.stopSelf();
//   });
// }
//
// Future<void> playAlarm(
//     FlutterLocalNotificationsPlugin plugin,
//     AudioPlayer player,
//     String songPath,
//     ) async {
//   final SharedPreferences prefs = await SharedPreferences.getInstance();
//   final bool isAlarmActive = prefs.getBool('is_alarm_active') ?? false;
//
//   if (isAlarmActive) {
//     print("Alarm already active, skipping");
//     return;
//   }
//
//   if (songPath.isEmpty) {
//     print("No valid song path for alarm");
//     return;
//   }
//
//   try {
//     await prefs.setBool('is_alarm_active', true);
//     if (player.playing) {
//       print("Stopping current alarm playback");
//       await player.stop();
//     }
//     await player.seek(Duration.zero);
//     print("Setting alarm file path: $songPath");
//     await player.setFilePath(songPath);
//     await player.setLoopMode(LoopMode.one);
//     await player.play();
//
//     await plugin.show(
//       888,
//       'Battery Level Reached',
//       'Tap to stop alarm',
//       NotificationDetails(
//         android: AndroidNotificationDetails(
//           'battery_alarm_channel',
//           'Battery Alarm',
//           importance: Importance.max,
//           priority: Priority.high,
//           playSound: false,
//           ongoing: false,
//           actions: [
//             AndroidNotificationAction(
//               'stop_alarm',
//               'Stop Alarm',
//               showsUserInterface: false,
//               cancelNotification: true, // Auto-cancel when action is tapped
//             ),
//           ],
//         ),
//       ),
//       payload: 'stop_alarm',
//     );
//     print('Alarm notification shown with ID 888');
//   } catch (e) {
//     print('Error playing alarm: $e');
//     await prefs.setBool('is_alarm_active', false);
//   }
// }

// // chatgpt new code
//

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
