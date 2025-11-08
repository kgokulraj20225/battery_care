import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'controller_battery.dart';


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

  Future<void> get_user_selected_value()async{
    SharedPreferences perf = await SharedPreferences.getInstance();
    selectedNumber.value=perf.getInt('user_picker_value')?? bat.battery_level.value;
  }

}
