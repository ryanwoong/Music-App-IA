

import 'package:file_picker/file_picker.dart';

class SongModel {
  // final PlatformFile? songFile;
  // final PlatformFile? imageFile;
  // final String? songName;
  // final String? artists;
  // final bool isFeatured;
  // final bool isTrending;
  

  // SongModel({ required this.songFile, required this.imageFile, required this.songName, required this.artists, required this.isFeatured, required this.isTrending});
  
  
  final String? songName;
  final String? artist;
  final bool isTrending;
  final bool isFeatured;

  SongModel({ this.songName, required this.artist, required this.isTrending, required this.isFeatured });

}

class SongFiles {
  final PlatformFile? songFile;
  final PlatformFile? imageFile;

  SongFiles({ this.songFile, this.imageFile });

}
