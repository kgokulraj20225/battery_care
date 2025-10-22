import 'dart:async';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trial_app/battery_info_pages/controller_battery/controller_battery.dart';
import 'package:trial_app/service/background_service.dart';

class song_picker_controller extends GetxController {
  var selected_song = 'No Select Song'.obs;
  var selected_song_path = ''.obs;
  var alarm_on_off = false.obs;
  final battery_info battery = Get.find();
  final player = AudioPlayer();

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

  void get_user_select_songs()async{
    SharedPreferences perf =await SharedPreferences.getInstance();
    selected_song.value=perf.getString('selected_song_name')?? 'No Song Selected';
    selected_song_path.value=perf.getString('selected_song_path')?? selected_song_path.value;
    alarm_on_off.value=perf.getBool('alarm_switch_on_off')?? false;
  }

  void alarm_on_off_switch() async{
    alarm_on_off.value = !alarm_on_off.value;
    SharedPreferences perf = await SharedPreferences.getInstance();
    perf.setBool('alarm_switch_on_off', alarm_on_off.value);
    final service = FlutterBackgroundService();
    if(alarm_on_off.value){
      await initializedService();
    }else {
      service.invoke('stopService'); // stop background
    }
    print('alarm : ${alarm_on_off.value}');
  }

  Future<void> playselectedsongs() async {
    if (selected_song_path.value.isEmpty&& selected_song_path=='') return;
    await player.setFilePath(selected_song_path.value);

    await player.setLoopMode(LoopMode.one);
    await player.play();
  }

  Future<void> stopSong() async {
    await player.stop();
    await player.setLoopMode(LoopMode.off);
  }

  void alarm_on_off_button_fun(int value) {
    if (alarm_on_off.value && value == battery.battery_level.value) {
      playselectedsongs();
    } else {
      stopSong();
    }
  }
}

class NumberController extends GetxController {
  var selectedNumber = 0.obs; // observable number
  final battery_info bat = Get.put(battery_info());

  void set_battery_level() async {
    await bat.getbattery_level();
    selectedNumber.value = bat.battery_level.value;
  }

  void set_user_selected_value(int value) async{
    SharedPreferences perf = await SharedPreferences.getInstance();
    perf.setInt('user_picker_value', value);
  }

  void get_user_selected_value()async{
    SharedPreferences perf = await SharedPreferences.getInstance();
    selectedNumber.value=perf.getInt('user_picker_value')?? bat.battery_level.value;
  }

}
