import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:trial_app/battery_info_pages/binding_battery/binding_battery.dart';
import 'package:trial_app/battery_info_pages/pages_battery/song_picker.dart';
import 'package:trial_app/route/app_route.dart';
import 'package:trial_app/service/background_service.dart';

import 'battery_info_pages/controller_battery/controller_battery.dart';
import 'battery_info_pages/controller_battery/song_picker_controller.dart';
import 'battery_info_pages/pages_battery/animation_pages.dart';



void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  // Get.put(battery_info());
  // Get.put(song_picker_controller());
  // Get.put(NumberController());
  //
  // Get.put(song_picker_controller());
  // await initializedService();
  runApp(myapp());
}

class myapp extends StatefulWidget {
  const myapp({super.key});

  @override
  State<myapp> createState() => _myappState();
}

class _myappState extends State<myapp> {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.home,
      getPages: AppRoutes.route,
    );
  }
}
