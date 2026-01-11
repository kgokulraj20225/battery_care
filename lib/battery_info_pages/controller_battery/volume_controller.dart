import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trial_app/battery_info_pages/controller_battery/song_picker_controller.dart';
import 'package:volume_controller/volume_controller.dart';

class volume_controller extends GetxController {
  final song_picker_controller song = Get.find();
  final volumes = 0.0.obs;
  double check_vol = -1;
  final allow = false.obs;

  @override
  void onInit() {
    get_current_volume();
    super.onInit();
  }

  @override
  void onClose() {
    VolumeController.instance.removeListener();
    super.onClose();
  }



  Future<void> set_current_volume(double value) async {
    VolumeController.instance.setVolume(value);
  }

  Future<void> full_volume() async {
    volumes.value = 1.0;
    set_current_volume(volumes.value);
  }

  Future<void> get_current_volume() async {
    volumes.value = await VolumeController.instance.getVolume();
    VolumeController.instance.addListener((vol) {
      volumes.value = vol;
    });
  }

  Future<void> get_allow_info() async {
    SharedPreferences perf = await SharedPreferences.getInstance();
    allow.value=!allow.value;
    await perf.setBool('allow', allow.value);
    check_user_phone_volume();
  }


  Future<void> get_user_permission() async {
    if (song.alarm_on_off.value == false) return;
    if (allow.value==false) {
      Get.dialog(
          TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.7, end: 1.0),
              duration: Duration(milliseconds: 300),
              curve: Curves.elasticIn,
              builder: (context, scale, child) => Transform.scale(
                    scale: scale,
                    child: AlertDialog(
                      title: Text(
                        'Volume Control',
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                      content: Container(
                        height: 120,
                        // color: Colors.red,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            OutlinedButton(
                                onPressed: () async {
                                  get_allow_info();

                                  Get.back();
                                },
                                style: OutlinedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                    side: BorderSide(
                                        width: 0.1, color: Colors.red)),
                                child: Text(
                                  'Allow',
                                  style: TextStyle(color: Colors.white),
                                )),
                            OutlinedButton(
                                onPressed: () {
                                  Get.back();
                                },
                                child: Text(
                                  'Cancel',
                                  style: TextStyle(
                                    color: Colors.red,
                                  ),
                                ))
                          ],
                        ),
                      ),
                    ),
                  )),
          barrierDismissible: true);
    }
  }

  Future<void> check_user_phone_volume() async {

    if (song.alarm_on_off.value == false) return;
    if(allow.value) {
      if (volumes.value <= 0.5 ||
          volumes.value <= 0.8 ||
          VolumeController.instance.isMuted() == true) {
        Get.dialog(AlertDialog(
          title: Text(
            'volume low!',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          ),
          content: Container(
            // color: Colors.white,
            height: 255,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Obx(
                      () =>
                      AnimatedContainer(
                          duration: Duration(seconds: 1),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                  color: Colors.black, width: 2)),
                          height: 100,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Manual Volume Control',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                                Slider(
                                  value: volumes.value,
                                  onChanged: (double value) {
                                    set_current_volume(value);
                                  },
                                  max: 1.0,
                                  min: 0.0,
                                  activeColor:
                                  volumes.value > 0.8 ? Colors.red : Colors
                                      .blue,
                                ),
                              ],
                            ),
                          )),
                ),
                TextButton.icon(
                  onPressed: () {
                    full_volume();
                    Get.back();
                    Get.snackbar('Waring!',
                        'please decrease the volume, if your are using headset',
                        duration: Duration(seconds: 5),
                        snackPosition: SnackPosition.BOTTOM);
                  },
                  icon: Icon(
                    Icons.volume_up,
                    size: 60,
                    color: Colors.blue,
                  ),
                  label: Text('   full Volume'),
                ),
                TextButton.icon(
                  onPressed: () {},
                  icon: Icon(
                    Icons.vibration,
                    size: 60,
                    color: Colors.blue,
                  ),
                  label: Text('   Vibration'),
                )
              ],
            ),
          ),
          backgroundColor: Colors.white,
        ));
      }
    }
  }
}
