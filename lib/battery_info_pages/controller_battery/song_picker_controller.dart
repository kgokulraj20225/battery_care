import 'dart:async';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trial_app/battery_info_pages/controller_battery/controller_battery.dart';
import 'package:trial_app/service/Foreground_service/foreground_service.dart';
import 'package:trial_app/service/background_service.dart';
import '../../service/Notification_service.dart';
import 'number_controller.dart';

class song_picker_controller extends GetxController {
  var selected_song = 'No Select Song'.obs;
  var selected_song_path = ''.obs;
  var alarm_on_off = false.obs;
  final battery_info battery = Get.find();
  NumberController get number => Get.find();
  final player = AudioPlayer();
  Timer? _debounce;

  @override
  void onInit() {
    Foreground_Service.service1.on('changer_alarm_sync').listen((_) async {
      alarm_on_off.value=false;
      SharedPreferences perf = await SharedPreferences.getInstance();
      perf.setBool('alarm_switch_on_off', alarm_on_off.value);
    });
    super.onInit();
  }

  Future<void> song_picker() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.audio,
    );
    if (result != null && result.files.single.path != null) {
      selected_song.value = result.files.single.name;
      selected_song_path.value = result.files.single.path!;
      SharedPreferences perf = await SharedPreferences.getInstance();
      perf.setString('selected_song_name', selected_song.value);
      perf.setString('selected_song_path', selected_song_path.value);
    } else {
      print('file is not found');
    }
  }

  Future<void> get_user_select_songs() async {
    SharedPreferences perf = await SharedPreferences.getInstance();
    selected_song.value =
        perf.getString('selected_song_name') ?? 'No Song Selected';
    selected_song_path.value =
        perf.getString('selected_song_path') ?? selected_song_path.value;
    alarm_on_off.value = perf.getBool('alarm_switch_on_off') ?? false;
  }

  Future<void> playselectedsongs() async {
    if (selected_song_path.value.isEmpty&& selected_song_path=='') return;
    await player.setFilePath(selected_song_path.value);
    await player.setLoopMode(LoopMode.one);
    await player.play();

  }

  void alarm_on_off_switch()async{
    alarm_on_off.value = !alarm_on_off.value;
    SharedPreferences perf = await SharedPreferences.getInstance();
    perf.setBool('alarm_switch_on_off', alarm_on_off.value);
  }

  // og code
  void alarm_on_off_switch_do_logic() async {
    final service = FlutterBackgroundService();
    if (alarm_on_off.value) {
      if(battery.onlys_charging.value ) {
        if(battery.battery_state.value=='discharging'){
          service.invoke('stopService');
          return;
        }
      }
      await service.startService();
      service.invoke('updateSettings', {
        "batteryLevel": number.selectedNumber.value,
        "songPath": selected_song_path.value,
        "alarm": alarm_on_off.value
      });
    } else {
      service.invoke('stopService'); // stop background
      stopSong();
    }
    // await Future.delayed(const Duration(milliseconds: 300));
    print('alarm : ${alarm_on_off.value}');
  }

  // chat gpt code
  // void alarm_on_off_switch_do_logic(int value) async {
  //   final service = FlutterBackgroundService();
  //
  //   // Cancel previous pending work while user is still scrolling
  //   _debounce?.cancel();
  //
  //   _debounce = Timer(const Duration(milliseconds: 250), () async {
  //     // Code runs only AFTER scrolling stops for 250ms
  //     if (alarm_on_off.value) {
  //       if (value != battery.battery_level.value) {
  //         service.invoke('stopAlarm');
  //       }
  //       initializeService();
  //     } else {
  //       service.invoke('stopService');
  //       stopSong();
  //     }
  //
  //     print("alarm : ${alarm_on_off.value}, value:$value");
  //   });
  // }




  Future<void> stopSong() async {
    await player.stop();
    await player.setLoopMode(LoopMode.off);
  }

  Future<void> initializeAlarmState() async {
    await number.get_user_selected_value();
    await get_user_select_songs();
    if (alarm_on_off.value) {
      alarm_on_off_switch_do_logic(

        );
    }
  }
}


