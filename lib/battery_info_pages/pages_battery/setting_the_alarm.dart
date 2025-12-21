import 'package:battery_plus/battery_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../service/background_service.dart';
import '../../service/battery_optimize_code.dart';
import '../controller_battery/animation_controller.dart';
import '../controller_battery/controller_battery.dart';
import '../controller_battery/number_controller.dart';
import '../controller_battery/song_picker_controller.dart';

class set_alarm_to_cutoff extends StatefulWidget {
  const set_alarm_to_cutoff({super.key});

  @override
  State<set_alarm_to_cutoff> createState() => _set_alarm_to_cutoffState();
}

class _set_alarm_to_cutoffState extends State<set_alarm_to_cutoff> {
  final song_picker_controller song = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: Obx(
          ()=> AppBar(
            title: Text('Alarm page',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
            centerTitle: true,
            backgroundColor: song.alarm_on_off.value==true?Colors.green:Colors.red,
          ),
        ),
      ),
      body: Alarm_scroll_Wheel(),
    );
  }
}

class Alarm_scroll_Wheel extends StatefulWidget {
  const Alarm_scroll_Wheel({super.key});

  @override
  State<Alarm_scroll_Wheel> createState() => _Alarm_scroll_WheelState();
}

class _Alarm_scroll_WheelState extends State<Alarm_scroll_Wheel>
    with SingleTickerProviderStateMixin {
  final NumberController c = Get.find();
  final battery_info c1 = Get.find();
  final song_picker_controller song = Get.find();
  final animation_controller animate = Get.find();
  final Battery battery = Battery();

  @override
  void initState() {
    super.initState();
    // c.set_battery_level();
    // song.initializeAlarmState();
    // get_anime_value();
    // song.alarm_on_off_switch_do_logic(c.selectedNumber.value);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Set the Battery level',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: AnimatedContainer(
                  duration: Duration(seconds: 1),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.black, width: 2)),
                  height: 100,
                  child: Center(
                    child: SizedBox(
                        // width: 300,
                        height: 200, // adjust as needed
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Obx(
                              () => NumberPicker(
                                value: c.selectedNumber.value,
                                minValue: 0,
                                maxValue: 100,
                                itemHeight: 100,
                                axis: Axis.horizontal,
                                textStyle: TextStyle(color: Colors.grey, fontSize: 20),
                                selectedTextStyle: TextStyle(
                                    color: Colors.black, fontSize: 30),
                                onChanged: (value)=>{
                                  c.selectedNumber.value = value,
                                  c.set_user_selected_value(value),
                                  song.alarm_on_off_switch_do_logic(),
                                // await initializeService(),
                                  print('user picker number :${c.selectedNumber.value}')
                                },
                                decoration: BoxDecoration(
                                  border: Border(
                                    top: BorderSide(
                                        color: Colors.white, width: 2),
                                    bottom: BorderSide(
                                        color: Colors.white, width: 2),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 18.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text('the Selected battery level is:',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        )),
                    Padding(
                      padding: const EdgeInsets.only(left: 18.0),
                      child: Obx(() => Text('${c.selectedNumber.value}',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ))),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: 18.0, left: 8, right: 8, bottom: 8),
                child: GestureDetector(
                  onTap: () {
                    song.song_picker();
                  },
                  child: AnimatedContainer(
                    duration: Duration(seconds: 1),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.black, width: 2)),
                    height: 100,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: Text('Set the Music',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              )),
                        ),
                        Lottie.asset(
                          "assets/lottie/loading.json",
                          controller: animate.animationController,
                          onLoaded: (co) {
                            animate.animationController..duration = co.duration;
                          },
                          width: 150,
                          height: 100,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 18.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('the Selected Song is:',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        )),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 18.0),
                        child: Obx(() => SingleChildScrollView(
                              child: Text('${song.selected_song.value}',
                                  softWrap: true,
                                  maxLines: 4,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  )),
                            )),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: 18.0, left: 8, right: 8, bottom: 8),
                child: Obx(
                  ()=> GestureDetector(
                    onTap: () {

                    },
                    child: AnimatedContainer(
                      duration: Duration(seconds: 1),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.black, width: 2)),
                      height: 100,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(18.0),
                            child: Text('Alarm Works only Charging',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                )),
                          ),
                          Switch(activeColor: Colors.green,
                              value: c1.onlys_charging.value, onChanged: (bool value){
                            c1.only_charging(value);
                            song.alarm_on_off_switch_do_logic();
                          }),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: 18.0, left: 8, right: 8, bottom: 8),
                child: Obx(
                  () => GestureDetector(
                    onTap: () async {
                      if (song.selected_song_path.isEmpty&&song.selected_song_path=='') {
                        // 🔔 Show animated alert box
                        Get.dialog(
                          Center(
                            child: TweenAnimationBuilder<double>(
                              tween: Tween(begin: 0.7, end: 1.0),
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.elasticIn,
                              builder: (context, scale, child) =>
                                  Transform.scale(
                                scale: scale,
                                child: AlertDialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  title: const Text(
                                    "No Song Selected",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  content: const Text(
                                    "Please select a song before turning on the alarm.",
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        song.song_picker();
                                        Get.back();
                                      },
                                      child: const Text(
                                        "OK",
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          barrierDismissible: true,
                          barrierColor: Colors.black54,
                        );
                      } else {
                        // await initializedService();
                        // await openBatteryOptimizationSettings();
                        song.alarm_on_off_switch();
                        song.alarm_on_off_switch_do_logic();
                        // song.alarm_on_off_button_fun();
                      }
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50)),
                      shadowColor: Colors.green.shade300,
                      elevation: 5,
                      clipBehavior: Clip.hardEdge,
                      child: AnimatedContainer(
                        duration: Duration(seconds: 2),
                        decoration: BoxDecoration(
                          color: song.alarm_on_off.value == true
                              ? Colors.red
                              : Colors.green,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        height: 70,
                        child: Center(
                          child: song.alarm_on_off.value == true
                              ? Text(
                                  'Cancel the Alarm',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                )
                              : Text(
                                  'Set the Alarm',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
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
    );
  }
}
