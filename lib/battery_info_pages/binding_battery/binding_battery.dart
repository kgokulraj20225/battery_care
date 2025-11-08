import 'package:get/get.dart';
import 'package:trial_app/battery_info_pages/controller_battery/controller_battery.dart';

import '../controller_battery/animation_controller.dart';
import '../controller_battery/number_controller.dart';
import '../controller_battery/song_picker_controller.dart';


class battery_binding extends Bindings{
  @override
  void dependencies() {
    Get.put(battery_info());
    Get.put(song_picker_controller());
    Get.put(NumberController());
    Get.put(animation_controller());
  }
}