import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trial_app/battery_info_pages/controller_battery/song_picker_controller.dart';

import 'controller_battery.dart';


class NumberController extends GetxController {
  var selectedNumber = 0.obs; // observable number
  final battery_info bat = Get.put(battery_info());
  final song_picker_controller song=Get.find();
  @override
  void onInit() {
    // ever(selectedNumber, (value){
    //   song.alarm_on_off_switch_do_logic(value);
    // });
    super.onInit();
  }

  void set_battery_level() async {
    await bat.getbattery_level();
    selectedNumber.value = bat.battery_level.value;
  }

  void set_user_selected_value(int value) async{
    SharedPreferences perf = await SharedPreferences.getInstance();
    perf.setInt('user_picker_value', value);
  }

  Future<void> get_user_selected_value()async{
    SharedPreferences perf = await SharedPreferences.getInstance();
    selectedNumber.value=perf.getInt('user_picker_value')?? bat.battery_level.value;
    bat.onlys_charging.value=perf.getBool('only_charging')??false;
  }

}
