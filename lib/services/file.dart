import 'dart:io';
import 'package:pep/classes/songImage.dart';
import 'package:pep/classes/songFile.dart';
import 'package:file_picker/file_picker.dart';

class FileService {


  Future<SongFile> pickAudioFile() async {
    
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
        return SongFile(statusMessage: "File OK", songFile: file);
        
      } else {
        return SongFile(statusMessage: "Please select a .mp3 or .wav file", songFile: null);
        // print("Please select a .mp3 or .wav file");
      }
    } else {
      // User exited
    }

    return SongFile(statusMessage: "", songFile: null);
  }

  Future<SongImage> pickImageFile() async {
    
    // Attempt to get file from user 
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    
    // If there is a file then filter the extension to only accept .mp3 and .wav files
    if (result != null) {
      PlatformFile file = result.files.first;
      if (file.extension == "png" || file.extension == "jpg") {
        print(file.name);
        print(file.bytes);
        print(file.size);
        print(file.extension);
        print(file.path);
        print(file.runtimeType);
        return SongImage(statusMessage: "File OK", songImage: file);
        
      } else {
        return SongImage(statusMessage: "Please select a .png or .jpg file", songImage: null);
        // print("Please select a .mp3 or .wav file");
      }
    } else {
      // User exited
    }

    return SongImage(statusMessage: "", songImage: null);
  }
}