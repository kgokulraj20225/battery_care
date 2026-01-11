import 'package:get/get.dart';
import 'package:trial_app/battery_info_pages/binding_battery/binding_battery.dart';
import 'package:trial_app/battery_info_pages/controller_battery/controller_battery.dart';

import '../battery_info_pages/pages_battery/about_app.dart';
import '../battery_info_pages/pages_battery/animation_pages.dart';
import '../battery_info_pages/pages_battery/setting_the_alarm.dart';
import '../battery_info_pages/pages_battery/song_picker.dart';

class AppRoutes{
  static const home='/home';
  static const settings='/settings';
  static const alarm_set_page='/alarm_set_page';
  static const about_apps ='/abouts_app';

  static final route=[
    GetPage(name: home, page: ()=>song_picker(),binding: battery_binding()),
    GetPage(name: settings, page: ()=>battery_info_pages(),binding: battery_binding()),
    GetPage(name: alarm_set_page, page: ()=>set_alarm_to_cutoff(),binding: battery_binding()),
    GetPage(name: about_apps, page: ()=>about_app(),binding: battery_binding()),
  ];
}