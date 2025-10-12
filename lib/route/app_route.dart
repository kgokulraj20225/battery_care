import 'package:get/get.dart';
import 'package:trial_app/battery_info_pages/binding_battery/binding_battery.dart';
import 'package:trial_app/battery_info_pages/controller_battery/controller_battery.dart';

import '../battery_info_pages/pages_battery/animation_pages.dart';
import '../battery_info_pages/pages_battery/song_picker.dart';

class AppRoutes{
  static const home='/home';
  static const settings='/settings';

  static final route=[
    GetPage(name: home, page: ()=>song_picker(),binding: battery_binding()),
    GetPage(name: settings, page: ()=>battery_info_pages()),
  ];
}