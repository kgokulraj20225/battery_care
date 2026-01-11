import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trial_app/battery_info_pages/controller_battery/volume_controller.dart';

class about_app extends StatefulWidget {
  const about_app({super.key});

  @override
  State<about_app> createState() => _about_appState();
}

class _about_appState extends State<about_app> {
  final volume_controller volumes = Get.find();
  @override
  void initState() {

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('About App',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),

      ),
      body: SingleChildScrollView(
        child: Column(
          children: [

            GestureDetector(
              onTap: (){
                Get.dialog(
                  AlertDialog(
                    title: Text('Allowed permission'),
                    content: Container(
                      height: 100,
                      child: Column(
                        children: [
                          Obx(
                            ()=> ListTile(
                              title: Text('Volume Control'),
                              trailing: IconButton(onPressed: (){
                                volumes.allow.value?volumes.get_allow_info():volumes.get_allow_info();
                              }, icon: volumes.allow.value==true?Icon(Icons.close_outlined,color: Colors.red,):Icon(Icons.check_circle,color: Colors.green,)),
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                );
              },
              child: ListTile(
                title: Text('Permission',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 25),),
                trailing: Icon(Icons.arrow_forward_ios),
              ),
            )
          ],
        ),
      )
    );
  }
}
