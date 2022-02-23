import 'package:file_picker/file_picker.dart';

class SongModel {

  final String? songName;
  final String? artist;

  SongModel({ this.songName, required this.artist});

}

class SongFiles {
  final PlatformFile? songFile;
  final PlatformFile? imageFile;

  SongFiles({ this.songFile, this.imageFile });

}
