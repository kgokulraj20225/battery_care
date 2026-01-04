// import 'dart:ui';
//
// import 'package:awesome_notifications/awesome_notifications.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter_background_service/flutter_background_service.dart';
//
// class NotificationInit {
//   static Future<void> init() async {
//     await AwesomeNotifications().initialize(
//       null,
//       [
//         NotificationChannel(
//           channelKey: 'foreground_service',
//           channelName: 'Foreground Service',
//           channelDescription: 'Battery alarm foreground service',
//           importance: NotificationImportance.Max,
//           locked: true,
//           playSound: false,
//         ),
//       ],
//     );
//
//     await AwesomeNotifications().setListeners(
//       onActionReceivedMethod: onActionReceived,
//     );
//
//     if (!await AwesomeNotifications().isNotificationAllowed()) {
//       await AwesomeNotifications().requestPermissionToSendNotifications();
//     }
//
//
//   }
//
//   @pragma('vm:entry-point')
//   static Future<void> onActionReceived(ReceivedAction action) async {
//     WidgetsFlutterBinding.ensureInitialized();
//     DartPluginRegistrant.ensureInitialized();
//
//     final service = FlutterBackgroundService();
//
//     if (action.buttonKeyPressed == 'STOP SOUND') {
//       service.invoke('stopAlarm');
//     }
//
//     if (action.buttonKeyPressed == 'STOP') {
//       service.invoke('stopService');
//     }
//   }
// }


import 'dart:ui';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter_background_service/flutter_background_service.dart';

class NotificationInit {
  static bool _initialized = false;

  static Future<void> init() async {
    if (_initialized) return;
    _initialized = true;

    await AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
          channelKey: 'foreground_service1',
          channelName: 'Battery Alarm',
          channelDescription: 'Battery alarm foreground service',
          importance: NotificationImportance.High,
          locked: true,
          playSound: false,
        ),
      ],
      debug: false, // ✅ REQUIRED FOR APK
    );

    await AwesomeNotifications().setListeners(
      onActionReceivedMethod: onActionReceived,
    );
  }

  // ✅ CALL THIS ONLY FROM UI BUTTON / TOGGLE
  static Future<void> requestPermissionIfNeeded() async {
    final allowed = await AwesomeNotifications().isNotificationAllowed();
    if (!allowed) {
      await AwesomeNotifications().requestPermissionToSendNotifications();
    }
  }

  // 🔐 BACKGROUND SAFE
  @pragma('vm:entry-point')
  static Future<void> onActionReceived(ReceivedAction action) async {
    DartPluginRegistrant.ensureInitialized();

    final service = FlutterBackgroundService();

    if (action.buttonKeyPressed == 'STOP SOUND') {
      service.invoke('stopAlarm');
    }

    if (action.buttonKeyPressed == 'STOP') {
      service.invoke('stopService');
    }
  }
}
