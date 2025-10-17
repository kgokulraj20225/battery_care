import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:get/get.dart';
import 'package:battery_plus/battery_plus.dart';
// import 'package:battery_info/battery_info_plugin.dart';

class battery_info extends GetxController with GetSingleTickerProviderStateMixin{
  final Battery battery = Battery();
  var battery_level = 0.obs;
  var battery_state = ''.obs;
  var op = false.obs;
  var battery_Saver=false.obs;
  late AnimationController lottieController;

  @override
  void onInit() {
    battery.onBatteryStateChanged.listen((state){
      battery_state.value=state.name;
      getbattery_level();
    });

    lottieController = AnimationController(vsync: this);
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
  void option(bool value) async{
    op.value=value;
  }
  void stopAnimation() {
    lottieController.stop();
  }
  void batterys_saver(bool value) async{
    battery_Saver.value=value;
  }

  Future<void> getbattery_level() async {
    battery_level.value = await battery.batteryLevel;
  }

  // void getbattery_state() async{
  //   final BatteryState state = await battery.batteryState;
  //   battery_state.value= state.name;
  //   print(battery_state);
  // }
}
