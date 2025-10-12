import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:trial_app/battery_info_pages/binding_battery/binding_battery.dart';
import 'package:trial_app/battery_info_pages/pages_battery/song_picker.dart';
import 'package:trial_app/route/app_route.dart';

import 'battery_info_pages/pages_battery/animation_pages.dart';



void main(){
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
