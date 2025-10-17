import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:numberpicker/numberpicker.dart';

import '../controller_battery/controller_battery.dart';
import '../controller_battery/song_picker_controller.dart';

class set_alarm_to_cutoff extends StatefulWidget {
  const set_alarm_to_cutoff({super.key});

  @override
  State<set_alarm_to_cutoff> createState() => _set_alarm_to_cutoffState();
}

class _set_alarm_to_cutoffState extends State<set_alarm_to_cutoff> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.red,
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

class _Alarm_scroll_WheelState extends State<Alarm_scroll_Wheel> {
  final NumberController c = Get.find();
  final battery_info c1=Get.find();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Obx(
        () => Padding(
          padding:  EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Set the Battery level',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,),),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: AnimatedContainer(duration: Duration(seconds: 1),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.black,width: 2)
                  ),
                  height: 100,
                  child: Center(
                    child: SizedBox(
                        // width: 300,
                        height: 200, // adjust as needed
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: NumberPicker(
                              value: c.selectedNumber.value,
                              minValue: 0,
                              maxValue: 100,
                              itemHeight: 100,
                              axis: Axis.horizontal,
                              textStyle: TextStyle(color: Colors.grey, fontSize: 20),
                              selectedTextStyle:
                              TextStyle(color: Colors.black, fontSize: 30),
                              onChanged: (value) => c.selectedNumber.value = value,
                              decoration: BoxDecoration(
                                border: Border(
                                  top: BorderSide(color: Colors.white, width: 2),
                                  bottom: BorderSide(color: Colors.white, width: 2),

                                ),
                              ),),
                          ),
                        )
                    ),
                  ),
                ),
              ),
              // SizedBox(
              //   width: 300,
              //   height: 200, // adjust as needed
              //   child: NumberPicker(
              //       value: c.selectedNumber.value,
              //       minValue: 0,
              //       maxValue: 100,
              //       step: 5,
              //       itemHeight: 60,
              //       axis: Axis.vertical,
              //       textStyle: TextStyle(color: Colors.grey, fontSize: 20),
              //       selectedTextStyle:
              //       TextStyle(color: Colors.white, fontSize: 30),
              //       onChanged: (value) => c.selectedNumber.value = value,
              //       decoration: BoxDecoration(
              //         border: Border(
              //           top: BorderSide(color: Colors.white24, width: 2),
              //           bottom: BorderSide(color: Colors.white24, width: 2),
              //         ),
              //       ),)
              // ),

            ],
          ),
        ),
      ),
    );
  }
}
