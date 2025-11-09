import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:get/get.dart';
import 'package:battery_plus/battery_plus.dart';
import 'package:trial_app/battery_info_pages/controller_battery/song_picker_controller.dart';

import 'number_controller.dart';
// import 'package:battery_info/battery_info_plugin.dart';

class battery_info extends GetxController with GetSingleTickerProviderStateMixin{
  final Battery battery = Battery();
  var battery_level = 0.obs;
  var battery_state = ''.obs;
  var op = false.obs;
  var battery_Saver=false.obs;
  late AnimationController lottieController;
  NumberController get number => Get.find();
  song_picker_controller get song=> Get.find();

  @override
  void onInit() {
    // battery.onBatteryStateChanged.listen((state){
    //   battery_state.value=state.name;
    //   getbattery_level();
    // });
    get_batter_state_fun();
    lottieController = AnimationController(vsync: this);

    // ever(battery_level, (state){
    //   song.alarm_on_off_switch_do_logic(state);
    // });
    super.onInit();
  }

  @override
  void onClose() {
    lottieController.dispose();
    super.onClose();
  }
  Color get maincolor{
    if(battery_Saver.value) return Colors.orange;
    if(battery_state.value=='charging') return Colors.green;
    return Colors.red;
  }

  void get_batter_state_fun(){
    battery.onBatteryStateChanged.listen((state){
      battery_state.value=state.name;
      getbattery_level();

    });
  }

  Future<void> getbattery_level() async {
    battery_level.value = await battery.batteryLevel;
    print('${battery_level.value}');
  }

  void option(bool value) async{
    op.value=value;

  }
  void stopAnimation() {
    lottieController.stop();
  }
  void batterys_saver(bool value) async{
    battery_Saver.value=value;
  }




  // void getbattery_state() async{
  //   final BatteryState state = await battery.batteryState;
  //   battery_state.value= state.name;
  //   print(battery_state);
  // }
}
