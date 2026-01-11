import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:lottie/lottie.dart';
import 'package:trial_app/battery_info_pages/controller_battery/animation_controller.dart';
import 'package:trial_app/battery_info_pages/pages_battery/animation_pages.dart';
import 'package:trial_app/route/app_route.dart';
import '../controller_battery/controller_battery.dart';
import '../controller_battery/number_controller.dart';
import '../controller_battery/song_picker_controller.dart';


class song_picker extends StatefulWidget {
  const song_picker({super.key});

  @override
  State<song_picker> createState() => _song_pickerState();
}

class _song_pickerState extends State<song_picker> {
  final song_picker_controller c = Get.find();
  final battery_info bt = Get.find();
  final animation_controller animate = Get.find();
  final NumberController number =Get.find();
  final AudioPlayer player=AudioPlayer();


  @override
  void initState() {
    print('indicator${bt.battery_state}');
    animate.get_anime_value();
    number.get_user_selected_value();
    c.get_user_select_songs();
    c.demo_fun_for_auto_start_app_cal_alarm();
    print('alarm is on or off : ${c.alarm_on_off.value}');

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(left: 22.0),
          child: Lottie.asset(
              'assets/lottie/Earth globe rotating with Seamless loop animation.json',
              height: 90,
              controller: animate.globe, onLoaded: (com) {
            animate.globe..duration = com.duration;
            // print('battery state: ${bt.battery_state.value}');
            // if(bt.battery_state.value == 'charging') {
            //   animate.globe.repeat();
            // } else {
            //   animate.globe.stop();
            // };
          }),
        ),
        actions: [
          IconButton(onPressed: (){
            Get.toNamed(AppRoutes.about_apps);
          }, icon: Icon(Icons.info))
        ],
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: ListView(
          physics: BouncingScrollPhysics(),
          children: [
            Padding(
              padding: EdgeInsets.only(top: 60.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Obx(
                    () => AnimatedContainer(
                      height: 15,
                      width: 50,
                      duration: Duration(seconds: 1),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                            color: bt.battery_Saver == true
                                ? Colors.orange
                                : bt.battery_state == 'charging'
                                    ? Colors.green
                                    : Colors.red,
                            width: 5),
                        boxShadow: [
                          BoxShadow(
                              color: bt.battery_Saver == true
                                  ? Colors.orange.shade300
                                  : bt.battery_state == 'charging'
                                      ? Colors.green.shade300
                                      : Colors.red.withOpacity(0.3),
                              blurRadius: 20)
                        ],
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(10)),
                      ),
                    ),
                  ),
                  Obx(() {
                    final double hights = 280;
                    final isCharging = bt.battery_state.value == 'charging';
                    final fillHeight = (bt.battery_level.value / 100) * hights;
                    final random = Random();
                    double _currentRadius = 0;
                    double getRandomRadius() => random.nextDouble() * 30;

                    return AnimatedContainer(
                      duration: const Duration(seconds: 1),
                      height: hights,
                      width: 200,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: bt.battery_Saver == true
                              ? Colors.orange
                              : isCharging
                                  ? Colors.green
                                  : Colors.red,
                          width: 5,
                        ),
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: bt.battery_Saver == true
                                ? Colors.orange.shade300
                                : isCharging
                                    ? Colors.green.withOpacity(0.3)
                                    : Colors.red.withOpacity(0.3),
                            blurRadius: 20,
                          )
                        ],
                      ),
                      child: Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          // Fill animation (background layer)
                          bt.op == true
                              ? AnimatedContainer(
                                  duration: const Duration(seconds: 1),
                                  height: fillHeight,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: bt.battery_Saver == true
                                        ? Colors.orange.shade300
                                        : isCharging
                                            ? Colors.green.withOpacity(0.6)
                                            : Colors.red.withOpacity(0.6),
                                    borderRadius: BorderRadius.vertical(
                                      bottom: Radius.circular(25),
                                      top: Radius.circular(
                                          bt.battery_level.value >= 90
                                              ? 25
                                              : -40),
                                    ),
                                  ),
                                )
                              : SizedBox(),

                          // Foreground content (icon + text)
                          Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (isCharging)
                                  Icon(
                                    Icons.battery_charging_full,
                                    color: bt.maincolor,
                                    size: 35,
                                    shadows: [
                                      Shadow(
                                          color: bt.maincolor, blurRadius: 20)
                                    ],
                                  ),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      '${bt.battery_level.value}',
                                      style: TextStyle(
                                        color: bt.maincolor,
                                        fontSize: 50,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 18.0),
                                      child: Text(
                                        '%',
                                        style: TextStyle(
                                          color: bt.maincolor,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                  // own code
                  // Obx(
                  //   ()=> AnimatedContainer(
                  //     height: 270,
                  //     width: 180,
                  //     duration: Duration(seconds: 1),
                  //     decoration: BoxDecoration(
                  //       color: Colors.white,
                  //       border: Border.all(color: bt.battery_state=='charging'? Colors.green:Colors.red, width: 5),
                  //       boxShadow: [BoxShadow(color: bt.battery_state=='charging'? Colors.green:Colors.red.withOpacity(0.3), blurRadius: 20)],
                  //       borderRadius: BorderRadius.circular(30),
                  //     ),
                  //     child: Center(child: Column(
                  //       mainAxisSize: MainAxisSize.min,
                  //       children: [
                  //         Obx(
                  //               ()=> bt.battery_state=='charging' ?Icon(Icons.battery_charging_full,color: Colors.green,size: 35,shadows: [Shadow(
                  //                 color: Colors.green.shade300,blurRadius: 20,
                  //               )],):SizedBox(),
                  //         ),
                  //         Row(
                  //           mainAxisSize: MainAxisSize.min,
                  //           children: [
                  //             // Obx(()=>Text('${bt.battery_state}')),
                  //             Text('${bt.battery_level.value}',style: TextStyle(color: bt.battery_state.value=='charging'? Colors.green:Colors.red,fontSize: 50),),
                  //             Padding(
                  //               padding: const EdgeInsets.only(top: 18.0),
                  //               child: Obx(()=> Text('%',style: TextStyle(color:  bt.battery_state.value=='charging'? Colors.green:Colors.red),)),
                  //             )
                  //           ],
                  //         ),
                  //       ],
                  //     )),
                  //   ),
                  // ),
                ],
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.only(top: 25.0),
            //   child: Align(
            //     alignment: Alignment.center,
            //     child: Obx(
            //       () => AnimatedContainer(
            //         decoration: BoxDecoration(
            //           boxShadow: [
            //             BoxShadow(
            //               color: bt.battery_state.value == 'charging'
            //                   ? Colors.green.shade300
            //                   : Colors.red.shade300,
            //               blurRadius: 20,
            //             )
            //           ],
            //           color: Colors.white,
            //           border: Border.all(
            //               color: bt.battery_state.value == 'charging'
            //                   ? Colors.green
            //                   : Colors.red,
            //               width: 3),
            //           borderRadius: BorderRadius.circular(20),
            //         ),
            //         duration: Duration(seconds: 1),
            //         height: 100,
            //         width: 200,
            //         child: Column(
            //           crossAxisAlignment: CrossAxisAlignment.center,
            //           mainAxisAlignment: MainAxisAlignment.center,
            //           children: [
            //             Text(
            //               '${bt.battery_state}',
            //               style: TextStyle(
            //                   color: bt.battery_state.value == 'charging'
            //                       ? Colors.green
            //                       : Colors.red,
            //                   fontSize: 20),
            //             ),
            //             Text(
            //               '${100 - bt.battery_level.value}% to Full charge',
            //               style: TextStyle(
            //                   color: bt.battery_state.value == 'charging'
            //                       ? Colors.green
            //                       : Colors.red,
            //                   fontSize: 18),
            //             ),
            //           ],
            //         ),
            //         // color: Colors.red,
            //       ),
            //     ),
            //   ),
            // ),
            Padding(
              padding: const EdgeInsets.only(top: 30.0, bottom: 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(
                    flex: 1,
                    child: Obx(
                      () => Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Get.toNamed(AppRoutes.alarm_set_page);
                            },
                            child: Container(
                              height: 100,
                              decoration: BoxDecoration(
                                  // color: Colors.red,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                      color: bt.battery_Saver == true
                                          ? Colors.orange
                                          : bt.battery_state == 'charging'
                                              ? Colors.green
                                              : Colors.red,
                                      width: 2)),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Flexible(
                                      child: Obx(() => Text(
                                            'Set the alarm',
                                            style: TextStyle(
                                                fontSize: 15,
                                                color: bt.battery_Saver == true
                                                    ? Colors.orange
                                                    : bt.battery_state ==
                                                            'charging'
                                                        ? Colors.green
                                                        : Colors.red),
                                            maxLines: 2,
                                            softWrap: true,
                                            overflow: TextOverflow.ellipsis,
                                          )),
                                    ),
                                    Lottie.asset(
                                      "assets/lottie/Alarm Clock.json",

                                      fit: BoxFit.contain,
                                      height: 70,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 18.0),
                            child: GestureDetector(
                              onTap: () {
                                Get.toNamed(AppRoutes.settings);
                              },
                              child: Container(
                                height: 100,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                        color: bt.battery_Saver == true
                                            ? Colors.orange
                                            : bt.battery_state == 'charging'
                                                ? Colors.green
                                                : Colors.red,
                                        width: 2)),
                                child: Center(
                                  child: ListTile(
                                    trailing: Lottie.asset(
                                      "assets/lottie/Gear.json",
                                      controller: animate.animationController,
                                      onLoaded: (animates) {
                                        animate.animationController
                                          ..duration = animates.duration;
                                      },
                                      width: 50,
                                      height: 100,
                                    ),
                                    leading: Text(
                                      'Settings',
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: bt.battery_Saver == true
                                              ? Colors.orange
                                              : bt.battery_state == 'charging'
                                                  ? Colors.green
                                                  : Colors.red),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Obx(
                        () => Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            AnimatedContainer(
                              decoration: BoxDecoration(
                                  color: bt.battery_Saver == true
                                      ? Colors.transparent
                                      : bt.battery_state.value == 'charging'
                                          ? Colors.transparent
                                          : Colors.red,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                      color: bt.battery_Saver == true
                                          ? Colors.orange
                                          : bt.battery_state.value == 'charging'
                                              ? Colors.green
                                              : Colors.transparent,
                                      width: 2)),
                              height: 160,
                              duration: Duration(seconds: 1),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Center(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    // mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        '${100 - bt.battery_level.value}%',
                                        style: TextStyle(
                                            fontSize: 45,
                                            color: bt.battery_Saver == true
                                                ? Colors.orange
                                                : bt.battery_state.value ==
                                                        'charging'
                                                    ? Colors.green
                                                    : Colors.white),
                                      ),
                                      Text(
                                        'to Full charge',
                                        style: TextStyle(
                                            color: bt.battery_Saver == true
                                                ? Colors.orange
                                                : bt.battery_state.value ==
                                                        'charging'
                                                    ? Colors.green
                                                    : Colors.white,
                                            fontSize: 18),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: AnimatedContainer(
                                decoration: BoxDecoration(
                                  color: bt.battery_Saver == true
                                      ? Colors.orange
                                      : bt.battery_state.value == 'charging'
                                          ? Colors.green
                                          : Colors.red,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                height: 50,
                                duration: Duration(seconds: 1),
                                child: Center(
                                  child: bt.battery_Saver == true
                                      ? Text(
                                          'Battery Saver',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20),
                                        )
                                      : Text(
                                          '${bt.battery_state}',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20),
                                        ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Obx(
                () => AnimatedContainer(
                  duration: Duration(seconds: 1),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      // boxShadow: [BoxShadow(
                      //     color: bt.op==true?Colors.orange.shade300:Colors.transparent,
                      //     blurRadius: 15,
                      //     spreadRadius: 2
                      // )],
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                          color: bt.battery_Saver == true
                              ? Colors.orange
                              : bt.battery_state == 'charging'
                                  ? Colors.green
                                  : Colors.red,
                          width: 2)),
                  height: 100,
                  child: Center(
                    child: ListTile(
                      leading: Text(
                        'Battery Saver',
                        style: TextStyle(
                            color: bt.battery_Saver == true
                                ? Colors.orange
                                : bt.battery_state == 'charging'
                                    ? Colors.green
                                    : Colors.red,
                            fontSize: 25),
                      ),
                      trailing: Switch(
                        activeColor: Colors.orangeAccent,
                        onChanged: (bool newValue) {
                          bt.batterys_saver(newValue);
                        },
                        value: bt.battery_Saver.value,
                      ),
                    ),
                  ),
                  // color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
