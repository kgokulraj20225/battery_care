// // import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// // import 'package:just_audio/just_audio.dart';
// // import 'package:permission_handler/permission_handler.dart';
// // import 'package:get/get.dart';
// // import 'package:trial_app/battery_info_pages/controller_battery/song_picker_controller.dart';
// //
// // class NotificationService {
// //   static final NotificationService _notificationService = NotificationService._internal();
// //   final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
// //   final AudioPlayer player = AudioPlayer();
// //
// //
// //   factory NotificationService() {
// //     return _notificationService;
// //   }
// //
// //   NotificationService._internal();
// //
// //   Future<void> init() async {
// //     try {
// //       const AndroidInitializationSettings initializationSettingsAndroid =
// //       AndroidInitializationSettings('@mipmap/ic_launcher');
// //       final InitializationSettings initializationSettings = InitializationSettings(
// //         android: initializationSettingsAndroid,
// //       );
// //       await flutterLocalNotificationsPlugin.initialize(
// //         initializationSettings,
// //           onDidReceiveNotificationResponse: (response) async {
// //             if (response.actionId == 'stop_alarm' || response.payload == 'stop_alarm') {
// //               await player.stop();
// //             }
// //           }
// //       );
// //
// //
// //       if (await Permission.notification.isDenied) {
// //         await Permission.notification.request();
// //       }
// //     } catch (e) {
// //       print("Notification initialization failed: $e");
// //     }
// //   }
// //
// //   Future<void> showNotification({
// //     required int id,
// //     required String title,
// //     required String body,
// //   }) async {
// //     try {
// //       const AndroidNotificationDetails androidPlatformChannelSpecifics =
// //       AndroidNotificationDetails(
// //         'your_channel_id',
// //         'your_channel_name',
// //         channelDescription: 'your_channel_description',
// //         importance: Importance.max,
// //         priority: Priority.high,
// //         actions: <AndroidNotificationAction>[
// //           AndroidNotificationAction(
// //             'stop_alarm',        // actionId
// //             'Stop Alarm',       // Button text
// //             showsUserInterface: false,
// //           ),
// //         ],
// //       );
// //       const NotificationDetails platformChannelSpecifics = NotificationDetails(
// //         android: androidPlatformChannelSpecifics,
// //       );
// //       await flutterLocalNotificationsPlugin.show(
// //         id,
// //         title,
// //         body,
// //         platformChannelSpecifics,
// //         payload: "stop_alarm"
// //       );
// //     } catch (e) {
// //       print("Failed to show notification: $e");
// //     }
// //   }
// // }
// //


import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:just_audio/just_audio.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:trial_app/battery_info_pages/controller_battery/song_picker_controller.dart';

@pragma('vm:entry-point')
void _notificationTapBackgroundHandler(NotificationResponse response) {
  // This runs in isolate when app is in background/terminated
  if (response.actionId == 'stop_alarm' || response.payload == 'stop_alarm') {
    final player = AudioPlayer();
    player.stop().then((_) {
      player.dispose(); // Clean up
    });
  }
}

class NotificationService {
  static final NotificationService _notificationService = NotificationService._internal();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  final AudioPlayer player = AudioPlayer();

  factory NotificationService() => _notificationService;
  NotificationService._internal();

  Future<void> init() async {
    try {
      const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

      const InitializationSettings initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid,
      );

      // Initialize with both foreground and background handlers
      await flutterLocalNotificationsPlugin.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse: (NotificationResponse response) {
          _handleNotificationResponse(response);
        },
        onDidReceiveBackgroundNotificationResponse: _notificationTapBackgroundHandler,
      );

      // Request notification permission
      if (await Permission.notification.isDenied) {
        await Permission.notification.request();
      }
    } catch (e) {
      print("Notification initialization failed: $e");
    }
  }

  // Shared handler for both foreground and background
  void _handleNotificationResponse(NotificationResponse response) {
    if (response.actionId == 'stop_alarm' || response.payload == 'stop_alarm') {
      Get.find<song_picker_controller>().stopSong();
    }
  }

  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    try {
      const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
        'alarm_channel_id',
        'Alarm Channel',
        channelDescription: 'Channel for alarm notifications',
        importance: Importance.max,
        priority: Priority.high,
        playSound: false, // We'll play sound via just_audio
        enableVibration: true,
        actions: <AndroidNotificationAction>[
          AndroidNotificationAction(
            'stop_alarm',
            'Stop Alarm',
            showsUserInterface: false, // Prevents opening UI
            cancelNotification: true,  // Dismiss notification on tap
          ),
        ],
      );

      const NotificationDetails platformDetails = NotificationDetails(android: androidDetails);

      await flutterLocalNotificationsPlugin.show(
        id,
        title,
        body,
        platformDetails,
        payload: 'stop_alarm', // Optional fallback
      );
    } catch (e) {
      print("Failed to show notification: $e");
    }
  }
}