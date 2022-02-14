import 'package:file_picker/file_picker.dart';

class SongFile {
  String? statusMessage;
  PlatformFile? songFile;
  SongFile({required this.statusMessage, required this.songFile});

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