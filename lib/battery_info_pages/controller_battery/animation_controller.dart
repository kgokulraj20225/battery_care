import 'package:battery_plus/battery_plus.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trial_app/battery_info_pages/controller_battery/controller_battery.dart';

class animation_controller extends GetxController
    with GetTickerProviderStateMixin {
  late AnimationController animationController;
  late AnimationController globe;
  final battery_info battery_states = Get.find();
  var animation=false.obs;
  var to_store_anime=false.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 1));
    globe = AnimationController(vsync: this, duration: Duration(seconds: 1));
    if (globe.duration != null) {
      if (battery_states.battery_state.value == 'charging') {
        globe.repeat();
      } else {
        globe.stop();
      }}
      print('${battery_states.battery_level.value}');
    }

    @override
    void onClose() {
      // TODO: implement onClose
      super.onClose();
      animationController.dispose();
      globe.dispose();
    }

    // void demo_fun(bool anis)async{
    //   demoanimation.value=anis;
    //   SharedPreferences pref = await SharedPreferences.getInstance();
    //   pref.setBool('anime_on_off', demoanimation.value);
    // }

    void stop(bool ani) async {
      animation.value = ani;
      SharedPreferences pref = await SharedPreferences.getInstance();
      pref.setBool('animes_on_off', animation.value);
      battery_states.option(ani);
      if (ani) {
        animationController.repeat();
      } else {
        animationController.stop();
      }
    }

    Future<void> get_anime_value() async {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      to_store_anime.value = preferences.getBool('animes_on_off') ?? false;
      if (to_store_anime.value) {
        animation.value = to_store_anime.value;
        stop(to_store_anime.value);
      }
    }


}