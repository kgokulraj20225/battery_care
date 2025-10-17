import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import 'package:trial_app/battery_info_pages/controller_battery/controller_battery.dart';

class song_picker_controller extends GetxController{
  var selected_song='select the song'.obs;
  Future<void> song_picker()async{
    FilePickerResult? result=await FilePicker.platform.pickFiles(
      type: FileType.audio,
      // allowedExtensions: ["mp3,m4a"],
    );
    if(result !=null && result.files.single.path!=null){
      selected_song.value=result.files.single.name;
      print(selected_song);
    }
    else{
      print('file is not found');
    }
  }


}

class NumberController extends GetxController {
  var selectedNumber = 0.obs; // observable number
  final battery_info bat = Get.put(battery_info());

  @override
  void onInit() async {
    super.onInit();

    // fetch battery level initially
    // await bat.getbattery_level();
    selectedNumber.value=bat.battery_level.value;
  }
}
