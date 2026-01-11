import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trial_app/battery_info_pages/controller_battery/animation_controller.dart';
import 'package:trial_app/battery_info_pages/controller_battery/controller_battery.dart';
import 'package:trial_app/battery_info_pages/controller_battery/volume_controller.dart';
// import 'package:trial_app/battery_info//';

class battery_info_pages extends StatefulWidget {
  const battery_info_pages({super.key});

  @override
  State<battery_info_pages> createState() => _battery_info_pagesState();
}

class _battery_info_pagesState extends State<battery_info_pages> {
  final battery_info con=Get.find();
  @override
  void initState() {
   // con.getbattery_state();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Settings',style: TextStyle(fontWeight: FontWeight.bold),),
      ),
      body: Features(),
    );
  }
}

class Features extends StatefulWidget {
  const Features({super.key});

  @override
  State<Features> createState() => _FeaturesState();
}

class _FeaturesState extends State<Features> {
  final battery_info bt=Get.find();
  final animation_controller animate=Get.find();
  final volume_controller volumess=Get.find();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Wrap(
        spacing: 0,
        runSpacing: 12,
        children: [
          Obx(
            ()=> AnimatedContainer(
              duration: Duration(seconds: 1),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [BoxShadow(
                    color: bt.op==true?Colors.purple.shade300:Colors.transparent,
                  blurRadius: 15,
                  spreadRadius: 2
                )],
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: bt.op==true?Colors.purple:Colors.black,width: 2)
              ),
              height: 100,
              child: Center(
                child: ListTile(
                  leading: Text('Animation',style: TextStyle(color: bt.op==true?Colors.purple:Colors.black,fontSize: 25),),
                  trailing:
                     Switch(
                      activeColor:Colors.deepPurple,
                      onChanged: (bool newValue) {

                        animate.stop(newValue);
                      },
                      value: animate.animation.value,
                    ),
                  ),
                ),
              // color: Colors.white,
            ),
          ),
          Obx(
            ()=> AnimatedContainer(
              duration: Duration(seconds: 1),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.black,width: 2)
              ),
              height: 100,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Media Volume',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                    Slider(value: volumess.volumes.value, onChanged: (double value) {
                      volumess.set_current_volume(value);
                    },max: 1.0,min:0.0,activeColor: volumess.volumes.value>0.8?Colors.red:Colors.blue,),
                  ],
                ),
              )
              // color: Colors.white,
            ),
          ),

        ],
      ),
    );
  }
}

