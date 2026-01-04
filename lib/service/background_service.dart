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
//
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
// // ------------------------------------------------------------
// // Initialize background service
// // ------------------------------------------------------------
// Future<void> initializeService() async {
//     final service = FlutterBackgroundService();
//
//     const AndroidNotificationChannel channel = AndroidNotificationChannel(
//         'battery_alarm_channel',
//         'Battery Alarm Service',
//         description: 'Triggers alarm when selected battery level is reached',
//         importance: Importance.max,
//         playSound: false,
//     );
//
//     final androidPlugin = notificationsPlugin
//         .resolvePlatformSpecificImplementation<
//         AndroidFlutterLocalNotificationsPlugin>();
//
//     await androidPlugin?.createNotificationChannel(channel);
//     await androidPlugin?.requestNotificationsPermission();
//
//     await service.configure(
//         androidConfiguration: AndroidConfiguration(
//             onStart: onStart,
//             isForegroundMode: true,
//             notificationChannelId: 'battery_alarm_channel',
//             initialNotificationTitle: 'Battery Alarm Active',
//             initialNotificationContent: 'Monitoring battery level...',
//             foregroundServiceNotificationId: 999,
//         ),
//         iosConfiguration: IosConfiguration(
//             autoStart: true,
//             onForeground: onStart,
//             onBackground: (_) => true,
//         ),
//     );
// }
//
// // ------------------------------------------------------------
// // Background service entry point
// // ------------------------------------------------------------
// @pragma('vm:entry-point')
// void onStart(ServiceInstance service) async {
//     DartPluginRegistrant.ensureInitialized();
//
//     final AudioPlayer player = AudioPlayer();
//     final SharedPreferences prefs = await SharedPreferences.getInstance();
//
//     // Read user-selected values
//     int selectedUserValue = prefs.getInt('user_picker_value') ?? 0;
//     String selectedUserSongPath = prefs.getString('selected_song_path') ?? '';
//     bool alarmOnOff = prefs.getBool('alarm_switch_on_off') ?? false;
//
//     DateTime? lastAlarmTime;
//     const cooldownDuration = Duration(seconds: 1);
//
//     // -------------------- Update Settings Listener --------------------
//     service.on('updateSettings').listen((event) async {
//         if (event != null) {
//             selectedUserValue = event["batteryLevel"];
//             selectedUserSongPath = event["songPath"];
//             alarmOnOff = event["alarm"];
//
//             if (service is AndroidServiceInstance) {
//                 service.setForegroundNotificationInfo(
//                     title: 'Battery Alarm Active',
//                     content: '$selectedUserValue battery level set to alarm...',
//                 );
//             }
//
//             final prefs = await SharedPreferences.getInstance();
//             prefs.setInt('user_picker_value', selectedUserValue);
//             prefs.setString('selected_song_path', selectedUserSongPath);
//             prefs.setBool('alarm_switch_on_off', alarmOnOff);
//
//             print("Updated battery level: $selectedUserValue");
//         }
//     });
//
//     // -------------------- Notification Initialization --------------------
//     final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//     FlutterLocalNotificationsPlugin();
//
//     await flutterLocalNotificationsPlugin.initialize(
//         const InitializationSettings(
//             android: AndroidInitializationSettings('@mipmap/ic_launcher'),
//         ),
//         onDidReceiveNotificationResponse:
//             (NotificationResponse response) async {
//             if (response.actionId == 'stop_alarm' ||
//                 response.payload == 'stop_alarm') {
//                 await stopAlarm(player, prefs, flutterLocalNotificationsPlugin);
//             }
//         },
//     );
//
//     // -------------------- Battery Listener --------------------
//     StreamSubscription<BatteryState>? batteryStateSubscription;
//     batteryStateSubscription =
//         battery.onBatteryStateChanged.listen((BatteryState state) async {
//             int level = await battery.batteryLevel;
//
//             print("Battery: $level%, target: $selectedUserValue, alarmOn: $alarmOnOff");
//
//             if (level == selectedUserValue && alarmOnOff) {
//                 if (level != selectedUserValue) {
//                     await player.stop();
//                     return;
//                 }
//
//                 if (lastAlarmTime == null ||
//                     DateTime.now().difference(lastAlarmTime!) > cooldownDuration) {
//                     print("Battery threshold reached, playing alarm");
//
//                     await playAlarm(
//                         flutterLocalNotificationsPlugin,
//                         player,
//                         prefs,
//                         selectedUserSongPath,
//                     );
//
//                     lastAlarmTime = DateTime.now();
//                 }
//             }
//         });
//
//     // -------------------- Stop Commands --------------------
//     service.on('stopAlarm').listen((event) async {
//         await stopAlarm(player, prefs, flutterLocalNotificationsPlugin);
//     });
//
//     service.on('stopService').listen((event) async {
//         await stopAlarm(player, prefs, flutterLocalNotificationsPlugin);
//         service.stopSelf();
//     });
// }
//
// // ------------------------------------------------------------
// // Play Alarm
// // ------------------------------------------------------------
// Future<void> playAlarm(
//     FlutterLocalNotificationsPlugin plugin,
//     AudioPlayer player,
//     SharedPreferences prefs,
//     String songPath,
//     ) async {
//     if (prefs.getBool('is_alarm_active') ?? false) {
//         print("Alarm already active, skipping");
//         return;
//     }
//
//     if (songPath.isEmpty) {
//         print("No song path set for alarm");
//         return;
//     }
//
//     try {
//         await prefs.setBool('is_alarm_active', true);
//
//         if (player.playing) {
//             await player.stop();
//         }
//
//         await player.setFilePath(songPath);
//         await player.setLoopMode(LoopMode.one);
//         await player.play();
//
//         await plugin.show(
//             999,
//             'Battery Level Reached',
//             'Tap to stop alarm',
//             NotificationDetails(
//                 android: AndroidNotificationDetails(
//                     'battery_alarm_channel',
//                     'Battery Alarm',
//                     importance: Importance.max,
//                     priority: Priority.high,
//                     playSound: false,
//                     actions: [
//                         AndroidNotificationAction(
//                             'stop_alarm',
//                             'Stop Alarm',
//                             showsUserInterface: false,
//                             cancelNotification: true,
//                         ),
//                     ],
//                 ),
//             ),
//             payload: 'stop_alarm',
//         );
//
//         print("Alarm playing and notification shown");
//     } catch (e) {
//         print("Error playing alarm: $e");
//         await prefs.setBool('is_alarm_active', false);
//     }
// }
//
// // ------------------------------------------------------------
// // Stop Alarm
// // ------------------------------------------------------------
// Future<void> stopAlarm(
//     AudioPlayer player,
//     SharedPreferences prefs,
//     FlutterLocalNotificationsPlugin plugin,
//     ) async {
//     if (player.playing) {
//         await player.stop();
//         await player.setLoopMode(LoopMode.off);
//     }
//
//     await prefs.setBool('is_alarm_active', false);
//     await plugin.cancel(999);
//
//     print("Alarm stopped");
// }



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
//     final service = FlutterBackgroundService();
//
//     const AndroidNotificationChannel channel = AndroidNotificationChannel(
//         'battery_alarm_channel',
//         'Battery Alarm Service',
//         description: 'Triggers alarm when selected battery level is reached',
//         importance: Importance.max,
//         playSound: false,
//     );
//
//     final androidPlugin = notificationsPlugin
//         .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
//     await androidPlugin?.createNotificationChannel(channel);
//     await androidPlugin?.requestNotificationsPermission();
//
//     await service.configure(
//         androidConfiguration: AndroidConfiguration(
//             onStart: onStart,
//             isForegroundMode: true,
//             notificationChannelId: 'battery_alarm_channel',
//             initialNotificationTitle: 'Battery Alarm Active',
//             initialNotificationContent: 'Monitoring battery level...',
//             foregroundServiceNotificationId: 999,
//         ),
//         iosConfiguration: IosConfiguration(
//             autoStart: true,
//             onForeground: onStart,
//             onBackground: (_) => true,
//         ),
//     );
//
//
// }
//
// @pragma('vm:entry-point')
// void onStart(ServiceInstance service) async {
//     DartPluginRegistrant.ensureInitialized();
//
//     final AudioPlayer player = AudioPlayer();
//
//     final SharedPreferences prefs = await SharedPreferences.getInstance();
//
//     // Read user-selected values
//     int selectedUserValue = prefs.getInt('user_picker_value') ?? 0;
//     String selectedUserSongPath = prefs.getString('selected_song_path') ?? '';
//     bool alarmOnOff = prefs.getBool('alarm_switch_on_off') ?? false;
//
//     DateTime? lastAlarmTime;
//     const cooldownDuration = Duration(minutes: 1);
//
//
//     service.on('updateSettings').listen((event) async {
//         if (event != null) {
//             selectedUserValue = event["batteryLevel"];
//             selectedUserSongPath = event["songPath"];
//             alarmOnOff = event["alarm"];
//
//             if (service is AndroidServiceInstance) {
//                 service.setForegroundNotificationInfo(
//                     title: 'Battery Alarm Active',
//                     content: '$selectedUserValue battery level set to alarm...',
//                 );
//             }
//
//             final prefs = await SharedPreferences.getInstance();
//             prefs.setInt('user_picker_value', selectedUserValue);
//             prefs.setString('selected_song_path', selectedUserSongPath);
//             prefs.setBool('alarm_switch_on_off', alarmOnOff);
//
//
//             print("Updated battery level: $selectedUserValue");
//         }
//     });
//
//
//     // Initialize notification plugin
//     final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//     FlutterLocalNotificationsPlugin();
//     await flutterLocalNotificationsPlugin.initialize(
//         const InitializationSettings(
//             android: AndroidInitializationSettings('@mipmap/ic_launcher'),
//         ),
//         onDidReceiveNotificationResponse: (NotificationResponse response) async {
//             if (response.actionId == 'stop_alarm' || response.payload == 'stop_alarm') {
//                 await stopAlarm(player, prefs, flutterLocalNotificationsPlugin);
//             }
//         },
//     );
//
//     // Set foreground notification for the service
//
//
//     // Listen for battery state changes
//     StreamSubscription<BatteryState>? batteryStateSubscription;
//     batteryStateSubscription = battery.onBatteryStateChanged.listen((BatteryState state) async {
//         int level = await battery.batteryLevel;
//         print("Battery: $level%, target: $selectedUserValue, alarmOn: $alarmOnOff");
//
//         if (level == selectedUserValue && alarmOnOff) {
//             if(level!=selectedUserValue){
//                 await player.stop();
//                 return;
//             }
//             if (lastAlarmTime == null || DateTime.now().difference(lastAlarmTime!) > cooldownDuration) {
//                 print("Battery threshold reached, playing alarm");
//                 await playAlarm(flutterLocalNotificationsPlugin, player, prefs, selectedUserSongPath);
//                 lastAlarmTime = DateTime.now();
//             }
//         }
//
//
//     });
//
//
//
//     // Listen for service commands
//     service.on('stopAlarm').listen((event) async {
//         await stopAlarm(player, prefs, flutterLocalNotificationsPlugin);
//     });
//
//     service.on('stopService').listen((event) async {
//         await stopAlarm(player, prefs, flutterLocalNotificationsPlugin);
//         // timer?.cancel();
//         service.stopSelf();
//     });
// }
//
// // Play alarm with notification
// Future<void> playAlarm(
//     FlutterLocalNotificationsPlugin plugin,
//     AudioPlayer player,
//     SharedPreferences prefs,
//     String songPath,
//     ) async {
//     if (prefs.getBool('is_alarm_active') ?? false) {
//         print("Alarm already active, skipping");
//         return;
//     }
//
//     if (songPath.isEmpty) {
//         print("No song path set for alarm");
//         return;
//     }
//
//     try {
//         await prefs.setBool('is_alarm_active', true);
//
//         if (player.playing) {
//             await player.stop();
//         }
//
//         await player.setFilePath(songPath);
//         await player.setLoopMode(LoopMode.one);
//         await player.play();
//
//         await plugin.show(
//             999,
//             'Battery Level Reached',
//             'Tap to stop alarm',
//             NotificationDetails(
//                 android: AndroidNotificationDetails(
//                     'battery_alarm_channel',
//                     'Battery Alarm',
//                     importance: Importance.max,
//                     priority: Priority.high,
//
//                     playSound: false,
//                     actions: [
//                         AndroidNotificationAction(
//                             'stop_alarm',
//                             'Stop Alarm',
//                             showsUserInterface: false,
//                             cancelNotification: true,
//                         ),
//                     ],
//                 ),
//             ),
//             payload: 'stop_alarm',
//         );
//         print("Alarm playing and notification shown");
//     } catch (e) {
//         print("Error playing alarm: $e");
//         await prefs.setBool('is_alarm_active', false);
//     }
// }
//
// // Stop alarm and cancel notification
// Future<void> stopAlarm(AudioPlayer player, SharedPreferences prefs,
//     FlutterLocalNotificationsPlugin plugin) async {
//     if (player.playing) {
//         await player.stop();
//         await player.setLoopMode(LoopMode.off);
//     }
//     await prefs.setBool('is_alarm_active', false);
//     await plugin.cancel(999);
//     print("Alarm stopped");
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
// final FlutterLocalNotificationsPlugin notificationsPlugin =
// FlutterLocalNotificationsPlugin();
// final battery = Battery();
//
// // Initialize background service
// Future<void> initializeService() async {
//     final service = FlutterBackgroundService();
//
//     const AndroidNotificationChannel channel = AndroidNotificationChannel(
//         'battery_alarm_channel',
//         'Battery Alarm Service',
//         description: 'Triggers alarm when selected battery level is reached',
//         importance: Importance.max,
//         playSound: false,
//     );
//
//     final androidPlugin = notificationsPlugin
//         .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
//     await androidPlugin?.createNotificationChannel(channel);
//     await androidPlugin?.requestNotificationsPermission();
//
//     await service.configure(
//         androidConfiguration: AndroidConfiguration(
//             onStart: onStart,
//             isForegroundMode: true,
//             notificationChannelId: 'battery_alarm_channel',
//             initialNotificationTitle: 'Battery Alarm Active',
//             initialNotificationContent: 'Monitoring battery level...',
//             foregroundServiceNotificationId: 999,
//         ),
//         iosConfiguration: IosConfiguration(
//             autoStart: true,
//             onForeground: onStart,
//             onBackground: (_) => true,
//         ),
//     );
// }
//
// @pragma('vm:entry-point')
// void onStart(ServiceInstance service) async {
//     DartPluginRegistrant.ensureInitialized();
//
//     final AudioPlayer player = AudioPlayer();
//     final SharedPreferences prefs = await SharedPreferences.getInstance();
//
//     // Read user-selected values
//     int selectedUserValue = prefs.getInt('user_picker_value') ?? 0;
//     String selectedUserSongPath = prefs.getString('selected_song_path') ?? '';
//     bool alarmOnOff = prefs.getBool('alarm_switch_on_off') ?? false;
//
//     DateTime? lastAlarmTime;
//     const cooldownDuration = Duration(minutes: 1);
//     Timer? timer;
//
//     // Initialize notification plugin
//     final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//     FlutterLocalNotificationsPlugin();
//     await flutterLocalNotificationsPlugin.initialize(
//         const InitializationSettings(
//             android: AndroidInitializationSettings('@mipmap/ic_launcher'),
//         ),
//         onDidReceiveNotificationResponse: (NotificationResponse response) async {
//             if (response.actionId == 'stop_alarm' || response.payload == 'stop_alarm') {
//                 await stopAlarm(player, prefs, flutterLocalNotificationsPlugin);
//             }
//         },
//     );
//
//     if (service is AndroidServiceInstance) {
//         service.setForegroundNotificationInfo(
//             title: 'Battery Alarm Active',
//             content: '$selectedUserValue% battery level set to alarm...',
//         );
//     }
//
//     // Periodic timer to poll battery level (every 30 seconds to balance responsiveness and battery usage)
//     StreamSubscription<BatteryState>? batteryStateSubscription;
//     batteryStateSubscription = battery.onBatteryStateChanged.listen((BatteryState state) async {
//         int level = await battery.batteryLevel;
//         print("Battery: $level%, target: $selectedUserValue, alarmOn: $alarmOnOff");
//
//         // // Stop alarm if playing but battery level no longer matches
//         // if (player.playing && level != selectedUserValue) {
//         //     print("Battery level changed, stopping alarm");
//         //     await stopAlarm(player, prefs, flutterLocalNotificationsPlugin);
//         //     return;
//         // }
//
//         // Trigger alarm if conditions met
//         if (level == selectedUserValue && alarmOnOff) {
//             // bool isActive = prefs.getBool('is_alarm_active') ?? false;
//             // if (lastAlarmTime == null || DateTime.now().difference(lastAlarmTime!) > cooldownDuration) {
//                 print("Battery threshold reached, playing alarm");
//                 await playAlarm(flutterLocalNotificationsPlugin, player, prefs, selectedUserSongPath);
//                 lastAlarmTime = DateTime.now();
//             }
//         // }
//     });
//
//     service.on('updateSettings').listen((event) async {
//         if (event != null) {
//             int newBatteryLevel = event["batteryLevel"];
//             String newSongPath = event["songPath"];
//             bool newAlarm = event["alarm"];
//
//             // Get current battery level to check if we need to stop alarm immediately
//             int currentLevel = await battery.batteryLevel;
//             bool wasActive = prefs.getBool('is_alarm_active') ?? false;
//
//             // Update locals
//             selectedUserValue = newBatteryLevel;
//             selectedUserSongPath = newSongPath;
//             alarmOnOff = newAlarm;
//
//             // Save to prefs
//             await prefs.setInt('user_picker_value', selectedUserValue);
//             await prefs.setString('selected_song_path', selectedUserSongPath);
//             await prefs.setBool('alarm_switch_on_off', alarmOnOff);
//
//             // Stop alarm immediately if necessary (e.g., turned off or level changed away)
//             if (wasActive && (currentLevel != selectedUserValue || !alarmOnOff)) {
//                 print("Settings updated, stopping alarm");
//                 await stopAlarm(player, prefs, flutterLocalNotificationsPlugin);
//             }
//
//             if (service is AndroidServiceInstance) {
//                 service.setForegroundNotificationInfo(
//                     title: 'Battery Alarm Active',
//                     content: '$selectedUserValue% battery level set to alarm...',
//                 );
//             }
//
//             print("Updated battery level: $selectedUserValue");
//         }
//     });
//
//     // Listen for service commands
//     service.on('stopAlarm').listen((event) async {
//         await stopAlarm(player, prefs, flutterLocalNotificationsPlugin);
//     });
//
//     service.on('stopService').listen((event) async {
//         await stopAlarm(player, prefs, flutterLocalNotificationsPlugin);
//         if (service is AndroidServiceInstance) {
//             service.stopSelf();  // 🔥 removes the notification
//         }
//     });
// }
//
// // Play alarm with notification
// Future<void> playAlarm(
//     FlutterLocalNotificationsPlugin plugin,
//     AudioPlayer player,
//     SharedPreferences prefs,
//     String songPath,
//     ) async {
//     if (prefs.getBool('is_alarm_active') ?? false) {
//         print("Alarm already active, skipping");
//         return;
//     }
//
//     if (songPath.isEmpty) {
//         print("No song path set for alarm");
//         return;
//     }
//
//     try {
//         await prefs.setBool('is_alarm_active', true);
//
//         if (player.playing) {
//             await player.stop();
//         }
//
//         await player.setFilePath(songPath);
//         await player.setLoopMode(LoopMode.one);
//         await player.play();
//
//         await plugin.show(
//             1000, // Different ID from foreground service (999)
//             'Battery Level Reached',
//             'Tap to stop alarm',
//             NotificationDetails(
//                 android: AndroidNotificationDetails(
//                     'battery_alarm_channel',
//                     'Battery Alarm',
//                     importance: Importance.max,
//                     priority: Priority.high,
//                     playSound: false,
//                     actions: [
//                         AndroidNotificationAction(
//                             'stop_alarm',
//                             'Stop Alarm',
//                             showsUserInterface: false,
//                             cancelNotification: true,
//                         ),
//                     ],
//                 ),
//             ),
//             payload: 'stop_alarm',
//         );
//         print("Alarm playing and notification shown");
//     } catch (e) {
//         print("Error playing alarm: $e");
//         await prefs.setBool('is_alarm_active', false);
//     }
// }
//
// // Stop alarm and cancel notification
// Future<void> stopAlarm(
//     AudioPlayer player,
//     SharedPreferences prefs,
//     FlutterLocalNotificationsPlugin plugin,
//     ) async {
//     if (player.playing) {
//         await player.stop();
//         await player.setLoopMode(LoopMode.off);
//     }
//     await prefs.setBool('is_alarm_active', false);
//     await plugin.cancel(1000); // Matching the alarm notification ID
//     print("Alarm stopped");
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
            autoStart: false,
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
    Timer? timer;

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

    // Listen for service commands
    service.on('stopAlarm').listen((event) async {
        await stopAlarm(player, prefs, flutterLocalNotificationsPlugin);
    });

    service.on('stopService').listen((event) async {
        await stopAlarm(player, prefs, flutterLocalNotificationsPlugin);
        service.stopSelf();

    });

    if (service is AndroidServiceInstance && alarmOnOff) {
        service.setForegroundNotificationInfo(
            title: 'Battery Alarm Active',
            content: '$selectedUserValue% battery level set to alarm...',
        );
    }

    // Periodic timer to poll battery level (every 30 seconds to balance responsiveness and battery usage)
    StreamSubscription<BatteryState>? batteryStateSubscription;
    batteryStateSubscription = battery.onBatteryStateChanged.listen((BatteryState state) async {
        int level = await battery.batteryLevel;
        print("Battery: $level%, target: $selectedUserValue, alarmOn: $alarmOnOff");

        // Trigger alarm if conditions met
        if (level == selectedUserValue && alarmOnOff) {
            // bool isActive = prefs.getBool('is_alarm_active') ?? false;
            // if (lastAlarmTime == null || DateTime.now().difference(lastAlarmTime!) > cooldownDuration) {
            print("Battery threshold reached, playing alarm");
            await playAlarm(flutterLocalNotificationsPlugin, player, prefs, selectedUserSongPath);
            lastAlarmTime = DateTime.now();
        }
        // }
    });

    service.on('updateSettings').listen((event) async {
        if (event != null) {
            int newBatteryLevel = event["batteryLevel"];
            String newSongPath = event["songPath"];
            bool newAlarm = event["alarm"];

            // Get current battery level to check if we need to stop alarm immediately
            int currentLevel = await battery.batteryLevel;
            bool wasActive = prefs.getBool('is_alarm_active') ?? false;

            // Update locals
            selectedUserValue = newBatteryLevel;
            selectedUserSongPath = newSongPath;
            alarmOnOff = newAlarm;

            // Save to prefs
            await prefs.setInt('user_picker_value', selectedUserValue);
            await prefs.setString('selected_song_path', selectedUserSongPath);
            await prefs.setBool('alarm_switch_on_off', alarmOnOff);

            // Stop alarm immediately if necessary (e.g., turned off or level changed away)
            if (wasActive && (currentLevel != selectedUserValue || !alarmOnOff)) {
                print("Settings updated, stopping alarm");
                await stopAlarm(player, prefs, flutterLocalNotificationsPlugin);
            }

            if (service is AndroidServiceInstance && alarmOnOff) {
                service.setForegroundNotificationInfo(
                    title: 'Battery Alarm Active',
                    content: '$selectedUserValue% battery level set to alarm...',
                );
            }

            print("Updated battery level: $selectedUserValue");
        }
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
            1000,
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
                            showsUserInterface: true,
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
Future<void> stopAlarm(
    AudioPlayer player,
    SharedPreferences prefs,
    FlutterLocalNotificationsPlugin plugin,
    ) async {
    if (player.playing) {
        await player.stop();
        await player.setLoopMode(LoopMode.off);
    }
    await prefs.setBool('is_alarm_active', false);
    await plugin.cancel(1000); // Matching the alarm notification ID
    print("Alarm stopped");
}
