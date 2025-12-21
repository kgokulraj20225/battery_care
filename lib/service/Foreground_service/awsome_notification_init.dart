import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter_background_service/flutter_background_service.dart';

class NotificationInit {
  static Future<void> init() async {
    await AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
          channelKey: 'foreground_service',
          channelName: 'Foreground Service',
          channelDescription: 'Battery alarm foreground service',
          importance: NotificationImportance.Max,
          locked: true,
          playSound: false,
        ),
      ],
    );

    await AwesomeNotifications().setListeners(
      onActionReceivedMethod: onActionReceived,
    );

    if (!await AwesomeNotifications().isNotificationAllowed()) {
      await AwesomeNotifications().requestPermissionToSendNotifications();
    }


  }

  @pragma('vm:entry-point')
  static Future<void> onActionReceived(ReceivedAction action) async {
    final service = FlutterBackgroundService();

    if (action.buttonKeyPressed == 'STOP SOUND') {
      service.invoke('stopAlarm');
    }

    if (action.buttonKeyPressed == 'STOP') {
      service.invoke('stopService');
    }
  }
}
