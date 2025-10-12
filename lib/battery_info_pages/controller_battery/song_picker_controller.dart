import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';

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