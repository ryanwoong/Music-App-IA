import 'package:file_picker/file_picker.dart';

class SongImage {
  String? statusMessage;
  PlatformFile? songImage;
  SongImage({required this.statusMessage, required this.songImage});

  PlatformFile? getImageFile() {
    return songImage;
  }

  String? getStatusMessage() {
    return statusMessage;
  }
 
}