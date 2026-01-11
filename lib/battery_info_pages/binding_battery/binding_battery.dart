import 'package:get/get.dart';
import 'package:trial_app/battery_info_pages/controller_battery/controller_battery.dart';
import 'package:trial_app/battery_info_pages/controller_battery/volume_controller.dart';

import '../controller_battery/animation_controller.dart';
import '../controller_battery/number_controller.dart';
import '../controller_battery/song_picker_controller.dart';


class battery_binding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(()=>battery_info());
    Get.lazyPut(()=>song_picker_controller());
    Get.lazyPut(()=>NumberController());
    Get.lazyPut(()=>animation_controller());
    Get.lazyPut(()=>volume_controller());
  }
}