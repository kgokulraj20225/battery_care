// correct code
// import 'dart:async';
// import 'dart:ui';
//
// import 'package:battery_plus/battery_plus.dart';
// import 'package:flutter_background_service/flutter_background_service.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:just_audio/just_audio.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();
// final battery = Battery();
//
// @pragma('vm:entry-point')
// Future<void> onStart(ServiceInstance service) async {
//   DartPluginRegistrant.ensureInitialized();
//
//   final SharedPreferences prefs = await SharedPreferences.getInstance();
//
//   int selectedUserValue = prefs.getInt('user_picker_value') ?? 0;
//   String selectedUserSongPath = prefs.getString('selected_song_path') ?? '';
//   bool alarmOnOff = prefs.getBool('alarm_switch_on_off') ?? false;
//
//   if (service is AndroidServiceInstance && alarmOnOff) {
//     service.setForegroundNotificationInfo(
//       title: 'Battery Alarm Active',
//       content: '$selectedUserValue% battery level set to alarm...',
//     );
//   }
//
//   service.on('stopAlarm').listen((_) async {
//     await Foreground_Service.stopAlarm1(prefs);
//   });
//
//   service.on('stopService').listen((_) async {
//     await Foreground_Service.stopAlarm1(prefs);
//     service.stopSelf();
//
//     service.invoke('changer_alarm_sync');
//     _plugin.cancel(77);
//   });
//
//   StreamSubscription<BatteryState>? batteryStateSubscription;
//   batteryStateSubscription = battery.onBatteryStateChanged.listen((BatteryState state) async {
//     int level = await battery.batteryLevel;
//     print("Battery: $level%, target: $selectedUserValue, alarmOn: $alarmOnOff");
//
//     // Trigger alarm if conditions met
//     if (level == selectedUserValue && alarmOnOff) {
//       // bool isActive = prefs.getBool('is_alarm_active') ?? false;
//       // if (lastAlarmTime == null || DateTime.now().difference(lastAlarmTime!) > cooldownDuration) {
//       print("Battery threshold reached, playing alarm");
//       await Foreground_Service.song_play(prefs, selectedUserSongPath);
//       await Foreground_Service.playAlarm1(prefs, selectedUserSongPath);
//       // lastAlarmTime = DateTime.now();
//     } else {
//       await Foreground_Service.stopAlarm1(prefs);
//     }
//     // }
//   });
//
//   service.on('updateSettings').listen((event) async {
//     if (event != null) {
//       int newBatteryLevel = event["batteryLevel"];
//       String newSongPath = event["songPath"];
//       bool newAlarm = event["alarm"];
//
//       // Get current battery level to check if we need to stop alarm immediately
//       int currentLevel = await battery.batteryLevel;
//       bool wasActive = prefs.getBool('is_alarm_active') ?? false;
//
//       // Update locals
//       selectedUserValue = newBatteryLevel;
//       selectedUserSongPath = newSongPath;
//       alarmOnOff = newAlarm;
//
//       // Save to prefs
//       await prefs.setInt('user_picker_value', selectedUserValue);
//       await prefs.setString('selected_song_path', selectedUserSongPath);
//       await prefs.setBool('alarm_switch_on_off', alarmOnOff);
//
//       // Stop alarm immediately if necessary (e.g., turned off or level changed away)
//       if (currentLevel != selectedUserValue || !alarmOnOff) {
//         print("Settings updated, stopping alarm");
//         await Foreground_Service.stopAlarm1(prefs);
//       }
//
//       if (service is AndroidServiceInstance && alarmOnOff) {
//         service.setForegroundNotificationInfo(
//           title: 'Battery Alarm Active',
//           content: '$selectedUserValue% battery level set to alarm...',
//         );
//       }
//
//       print("Updated battery level: $selectedUserValue");
//     }
//   });
// }
//
// class Foreground_Service {
//   static final service = FlutterBackgroundService();
//   static final AudioPlayer player = AudioPlayer();
//
//   static final AndroidNotificationChannel _channel = AndroidNotificationChannel(
//       'foreground_service', 'Foreground Service',
//       description: 'Foreground is started', importance: Importance.high);
//
//   static Future<void> init() async {
//     await _plugin
//         .resolvePlatformSpecificImplementation<
//             AndroidFlutterLocalNotificationsPlugin>()
//         ?.requestNotificationsPermission();
//
//     await _plugin.initialize(InitializationSettings(
//         android: AndroidInitializationSettings('@mipmap/ic_launcher')),onDidReceiveNotificationResponse: onaction);
//
//     await _plugin
//         .resolvePlatformSpecificImplementation<
//             AndroidFlutterLocalNotificationsPlugin>()
//         ?.createNotificationChannel(_channel);
//
//     await service.configure(
//       iosConfiguration: IosConfiguration(),
//       androidConfiguration: AndroidConfiguration(
//         onStart: onStart,
//         isForegroundMode: true,
//         initialNotificationTitle: 'Foreground service',
//         notificationChannelId: _channel.id,
//         foregroundServiceNotificationId: 999,
//         initialNotificationContent: "Foreground Service is running...",
//         autoStart: false,
//
//       ),
//     );
//   }
//
//   @pragma('vm:entry-point')
//   static void onaction(NotificationResponse response){
//
//   }
//
//   static Future<void> playAlarm1(prefs, String songPath) async {
//     if (prefs.getBool('is_alarm_active') ?? false) {
//       print("Alarm already active, skipping");
//       return;
//     }
//
//     if (songPath.isEmpty) {
//       print("No song path set for alarm");
//       return;
//     }
//
//     try {
//       // await AwesomeNotifications().createNotification(
//       //   content: NotificationContent(
//       //     id: 77,
//       //     channelKey: 'foreground_service',
//       //     title: 'Battery Care',
//       //     body: 'the battery percentage reached its limit',
//       //     category: NotificationCategory.Service,
//       //     autoDismissible: false,
//       //   ),
//       //   actionButtons: [
//       //     NotificationActionButton(
//       //       key: 'STOP SOUND',
//       //       label: 'STOP SOUND',
//       //       actionType: ActionType.SilentBackgroundAction,
//       //       showInCompactView: true,
//       //       autoDismissible: false,
//       //     ),
//       //     NotificationActionButton(
//       //       key: 'STOP',
//       //       label: 'Stop',
//       //       isDangerousOption: true,
//       //       showInCompactView: true,
//       //       actionType: ActionType.SilentBackgroundAction,
//       //       autoDismissible: false,
//       //     ),
//       //   ],
//       // );
//
//       await _plugin.show(
//           77,
//           'Battery Care',
//           'The Battery Percentage Reach Limit!',
//           NotificationDetails(
//               android: AndroidNotificationDetails(
//             _channel.id,
//             _channel.name,
//             channelDescription: _channel.description,
//             priority: Priority.high,
//             importance: Importance.high,
//
//           )));
//     } catch (e) {
//       print("Error playing alarm: $e");
//       await prefs.setBool('is_alarm_active', false);
//     }
//   }
//
//   static Future<void> song_play(prefs, String songPath) async{
//     await prefs.setBool('is_alarm_active', true);
//     await player.setFilePath(songPath);
//     await player.setLoopMode(LoopMode.one);
//     await player.play();
//   }
//
//   static Future<void> stopAlarm1(SharedPreferences prefs) async {
//     if (player.playing) {
//       await player.stop();
//       await player.setLoopMode(LoopMode.off);
//     }
//
//     await prefs.setBool('is_alarm_active', false);
//     // await notificationsPlugin.cancel(77); // Matching the alarm notification ID
//     print("Alarm stopped");
//   }
//
//   static FlutterBackgroundService get service1 => service;
// }

import 'dart:async';
import 'dart:ui';

import 'package:battery_plus/battery_plus.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trial_app/route/app_route.dart';


final battery = Battery();
@pragma('vm:entry-point')
Future<void> onStart(ServiceInstance service) async {
  DartPluginRegistrant.ensureInitialized();

  final SharedPreferences prefs = await SharedPreferences.getInstance();

  int selectedUserValue = prefs.getInt('user_picker_value') ?? 0;
  String selectedUserSongPath = prefs.getString('selected_song_path') ?? '';
  bool alarmOnOff = prefs.getBool('alarm_switch_on_off') ?? false;

  if (service is AndroidServiceInstance && alarmOnOff) {
    service.setForegroundNotificationInfo(
      title: 'Battery Alarm Active',
      content: '$selectedUserValue% battery level set to alarm...',
    );
  }

  service.on('stopAlarm').listen((_) async {
    await Foreground_Service.stopAlarm1(prefs);
  });

  service.on('stopService').listen((_) async {
    await Foreground_Service.stopAlarm1(prefs);
    Foreground_Service.plugin.cancel(77);
    service.stopSelf();

  });

  StreamSubscription<BatteryState>? batteryStateSubscription;
  batteryStateSubscription =
      battery.onBatteryStateChanged.listen((BatteryState state) async {
    int level = await battery.batteryLevel;
    print("Battery: $level%, target: $selectedUserValue, alarmOn: $alarmOnOff");

    // Trigger alarm if conditions met
    if (level == selectedUserValue && alarmOnOff) {
      // bool isActive = prefs.getBool('is_alarm_active') ?? false;
      // if (lastAlarmTime == null || DateTime.now().difference(lastAlarmTime!) > cooldownDuration) {
      print("Battery threshold reached, playing alarm");
      await Foreground_Service.playAlarm1(prefs,selectedUserSongPath);
      await Foreground_Service.song_play(prefs, selectedUserSongPath);

      // lastAlarmTime = DateTime.now();
    } else {
      await Foreground_Service.stopAlarm1(prefs);
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
      if (currentLevel != selectedUserValue || !alarmOnOff) {
        print("Settings updated, stopping alarm");
        await Foreground_Service.stopAlarm1(prefs);
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

class Foreground_Service {
  static final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();

  static FlutterLocalNotificationsPlugin get plugin => _plugin;

  static final service = FlutterBackgroundService();
  static final AudioPlayer player = AudioPlayer();

  static final AndroidNotificationChannel _channel = AndroidNotificationChannel(
      'foreground_service', 'Foreground Service',
      description: 'Foreground is started', importance: Importance.high);

  static Future<void> init() async {
    await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();

    await _plugin.initialize(InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher')),onDidReceiveNotificationResponse: onaction);

    await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_channel);

    await service.configure(
      iosConfiguration: IosConfiguration(),
      androidConfiguration: AndroidConfiguration(
        onStart: onStart,
        isForegroundMode: true,
        initialNotificationTitle: 'Foreground service',
        notificationChannelId: _channel.id,
        foregroundServiceNotificationId: 999,
        initialNotificationContent: "Foreground Service is running...",
        autoStart: false,
      ),
    );
  }

  @pragma('vm:entry-point')
  static void onaction(NotificationResponse response) {
    if (response.payload == 'page_change') {
      Get.toNamed(AppRoutes.alarm_set_page);
    }
  }

  static Future<void> playAlarm1(prefs,songPath) async {
    if (prefs.getBool('is_alarm_active') ?? false) {
      print("Alarm already active, skipping");
      return;
    }

    if (songPath.isEmpty) {
      print("No song path set for alarm");
      return;
    }
    try {
      // await AwesomeNotifications().createNotification(
      //   content: NotificationContent(
      //     id: 77,
      //     channelKey: 'foreground_service',
      //     title: 'Battery Care',
      //     body: 'the battery percentage reached its limit',
      //     category: NotificationCategory.Service,
      //     autoDismissible: false,
      //   ),
      //   actionButtons: [
      //     NotificationActionButton(
      //       key: 'STOP SOUND',
      //       label: 'STOP SOUND',
      //       actionType: ActionType.SilentBackgroundAction,
      //       showInCompactView: true,
      //       autoDismissible: false,
      //     ),
      //     NotificationActionButton(
      //       key: 'STOP',
      //       label: 'Stop',
      //       isDangerousOption: true,
      //       showInCompactView: true,
      //       actionType: ActionType.SilentBackgroundAction,
      //       autoDismissible: false,
      //     ),
      //   ],
      // );
      await _plugin.show(
          77,
          'Battery Percentage Reached',
          'Tap Here To Stop Alarm! ',
          payload: 'page_change',
          NotificationDetails(
              android: AndroidNotificationDetails(
            _channel.id,
            _channel.name,
            channelDescription: _channel.description,
            priority: Priority.high,
            importance: Importance.high,
          )));
    } catch (e) {
      print("Error playing alarm: $e");
      await prefs.setBool('is_alarm_active', false);
    }
  }

  static Future<void> song_play(prefs, String songPath) async {
    if(player.playing) return;

    await prefs.setBool('is_alarm_active', true);
    await player.setFilePath(songPath);
    await player.setLoopMode(LoopMode.one);
    await player.play();
    service.invoke('players',{
      "play":true
    });
  }

  static Future<void> stopAlarm1(SharedPreferences prefs) async {
    if (player.playing) {
      await player.stop();
      await player.setLoopMode(LoopMode.off);
    }

    await prefs.setBool('is_alarm_active', false);
    // await notificationsPlugin.cancel(77); // Matching the alarm notification ID
    print("Alarm stopped");
  }

  static FlutterBackgroundService get service1 => service;
}
