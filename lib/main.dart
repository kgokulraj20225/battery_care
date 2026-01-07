import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:trial_app/battery_info_pages/binding_battery/binding_battery.dart';
import 'package:trial_app/battery_info_pages/pages_battery/song_picker.dart';
import 'package:trial_app/route/app_route.dart';
import 'package:trial_app/service/Foreground_service/awsome_notification_init.dart';
import 'package:trial_app/service/Foreground_service/foreground_service.dart';
import 'package:trial_app/service/Notification_service.dart';
import 'package:trial_app/service/background_service.dart';

import 'battery_info_pages/controller_battery/controller_battery.dart';
import 'battery_info_pages/controller_battery/number_controller.dart';
import 'battery_info_pages/controller_battery/song_picker_controller.dart';
import 'battery_info_pages/pages_battery/animation_pages.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  // await NotificationInit.init();
  await Foreground_Service.init();
  final NotificationAppLaunchDetails? details =
  await Foreground_Service.plugin.getNotificationAppLaunchDetails();

  String? init_payload;

  if(details?.didNotificationLaunchApp ??false){
    init_payload=details!.notificationResponse!.payload;
  }

  // await initializeService();
  // await NotificationService().init();
  // Set background handler (MUST be top-level or static)
  // Get.put(battery_info(),permanent: true);
  // Get.put(song_picker_controller(), permanent:true);
  // Get.put(NumberController(),permanent: true);
  runApp(myapp(initplayload: init_payload,));
}



class myapp extends StatefulWidget {
  dynamic initplayload;
   myapp({super.key,this.initplayload});

  @override
  State<myapp> createState() => _myappState();
}

class _myappState extends State<myapp> {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute:widget.initplayload=='page_change'?AppRoutes.alarm_set_page:AppRoutes.home,
      getPages: AppRoutes.route,
    );
  }
}
