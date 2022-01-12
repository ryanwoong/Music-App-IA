

import 'package:file_picker/file_picker.dart';

class SongModel {

  final String? songName;
  final String? artist;
  final bool isTrending;
  final bool isFeatured;
  final num random;

  SongModel({ this.songName, required this.artist, required this.isTrending, required this.isFeatured, required this.random });

}

class SongFiles {
  final PlatformFile? songFile;
  final PlatformFile? imageFile;

  SongFiles({ this.songFile, this.imageFile });

}
