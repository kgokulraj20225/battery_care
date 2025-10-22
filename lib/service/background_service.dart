import 'dart:async';

import 'package:battery_plus/battery_plus.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trial_app/battery_info_pages/controller_battery/song_picker_controller.dart';

final FlutterLocalNotificationsPlugin notificationsPlugin =
    FlutterLocalNotificationsPlugin();


final battery = Battery();


// initialized background service
Future initializedService() async {
  final service = FlutterBackgroundService();
  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'battery_alarm_channel',
    'Battery Alarm Service',
    description: 'Triggers alarm when selected battery level is reached',
    importance: Importance.max,
  );

  await notificationsPlugin
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await service.configure(
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      isForegroundMode: true,
      notificationChannelId: 'battery_alarm_channel',
      initialNotificationTitle: 'Battery Alarm Active',
      initialNotificationContent: 'Monitoring battery level...',
    ),
    iosConfiguration: IosConfiguration(),
  );
  service.startService();
}

/// 🔹 Background entry point (runs continuously)
@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  final AudioPlayer player = AudioPlayer();
  final SharedPreferences perf = await SharedPreferences.getInstance();
  final int selected_user_value=perf.getInt('user_picker_value')??0;
  final String selected_user_song_path=perf.getString('selected_song_path')??'';
  final bool alarm_on_off_get=perf.getBool('alarm_switch_on_off')??false;


  const AndroidNotificationChannel chennal = AndroidNotificationChannel(
    'battery_alarm_channel',
    'Battery Alarm Service',
    description: 'Triggers alarm when selected battery level is reached',
    importance: Importance.max,
  );

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  await flutterLocalNotificationsPlugin.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      ),
      onDidReceiveNotificationResponse: (NotificationResponse response) async {
    await player.stop();
    await player.setLoopMode(LoopMode.off);
  });

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(chennal);

  Timer.periodic(const Duration(seconds: 15), (timer)async{
    int level = await battery.batteryLevel;
    if(level==selected_user_value && alarm_on_off_get){
      await playAlarm(flutterLocalNotificationsPlugin,player,selected_user_song_path);
    }
  });

  // Stop alarm manually from service
  service.on('stopAlarm').listen((event) async {
    await player.stop();
    print('Alarm manually stopped');
  });

  service.on('stopService').listen((event) async {
    await player.stop();
    print('Background service stopped');
    service.stopSelf();
  });

}

/// 🔹 Play alarm sound + show notification

Future<void> playAlarm(FlutterLocalNotificationsPlugin plugin,AudioPlayer player,String songpath) async {

  try {
    await player.setFilePath(songpath);
    await player.setLoopMode(LoopMode.one);
    await player.play();
    await plugin.show(
        999,
        'Battery Level Reached',
        'Tap to stop alarm',
        const NotificationDetails(
            android: AndroidNotificationDetails(
                'battery_alarm_channel', 'Battery Alarm',
                importance: Importance.max,
                priority: Priority.high,
                playSound: false,
                actions: <AndroidNotificationAction>[
                  AndroidNotificationAction('stop_alarm', 'Stop Alarm',
                      showsUserInterface: true)
                ])),
        payload: 'stop_alarm');
  }catch(e){
    print('Error playing alarm: $e');
  }
}
