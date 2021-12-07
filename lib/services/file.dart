import 'dart:io';

import 'package:file_picker/file_picker.dart';

class FileStructure {
  String? statusMessage;
  PlatformFile? songFile;
  FileStructure({required this.statusMessage, required this.songFile});

  PlatformFile? getSongFile() {
    return songFile;
  }
  
  String? getStatusMessage() {
    return statusMessage;
  }

  String? getSongBrief() {
    // String _songName = "${songFile!.name}"
    return songFile!.name;
  }

  
}

class FileService {


  Future<FileStructure> pickFile() async {
    
    // Attempt to get file from user 
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    
    // If there is a file then filter the extension to only accept .mp3 and .wav files
    if (result != null) {
      PlatformFile file = result.files.first;
      if (file.extension == "mp3" || file.extension == "wav") {
        print(file.name);
        print(file.bytes);
        print(file.size);
        print(file.extension);
        print(file.path);
        print(file.runtimeType);
        return FileStructure(statusMessage: "Success", songFile: file);
        
      } else {
        return FileStructure(statusMessage: "Please select a .mp3 or .wav file", songFile: null);
        // print("Please select a .mp3 or .wav file");
      }
    } else {
      // User exited
    }

    return FileStructure(statusMessage: "", songFile: null);

    

    

    // if (result != null) {
    //   PlatformFile file = result.files.first;

      
    //   // Uint8List fileBytes = result.files.first.bytes;
    //   // String fileName = result.files.first.name;

    //   // Upload file
    //   // await FirebaseStorage.instance.ref('uploads/$fileName').putData(fileBytes);
    // } else {

    // }
  }
}