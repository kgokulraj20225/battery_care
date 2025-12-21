import 'dart:async';
import 'dart:ui';
import 'package:audioplayers/audioplayers.dart';
import 'package:battery_plus/battery_plus.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();
final battery = Battery();

@pragma('vm:entry-point')
Future<void> onStart(ServiceInstance service) async {
DartPluginRegistrant.ensureInitialized();

final AudioPlayer player = AudioPlayer();
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

StreamSubscription<BatteryState>? batteryStateSubscription;
batteryStateSubscription = battery.onBatteryStateChanged.listen((BatteryState state) async {
  int level = await battery.batteryLevel;
  print("Battery: $level%, target: $selectedUserValue, alarmOn: $alarmOnOff");

  // Trigger alarm if conditions met
  if (level == selectedUserValue && alarmOnOff) {
    // bool isActive = prefs.getBool('is_alarm_active') ?? false;
    // if (lastAlarmTime == null || DateTime.now().difference(lastAlarmTime!) > cooldownDuration) {
    print("Battery threshold reached, playing alarm");
    // await playAlarm(flutterLocalNotificationsPlugin, player, prefs, selectedUserSongPath);
    // lastAlarmTime = DateTime.now();
  }
  // }
});



}

class Foreground_Service {
  final service = FlutterBackgroundService();

  static final AndroidNotificationChannel _channel = AndroidNotificationChannel(
      'foreground_service', 'Foreground Service',
      description: 'Foreground is started', importance: Importance.high);

  Future<void> init() async {
    await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();

    await _plugin.initialize(InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher')));

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


}
