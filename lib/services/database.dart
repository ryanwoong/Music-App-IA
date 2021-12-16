import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pep/models/song.dart';

class DatabaseService {
  final String? uid;
  final String? artist;

  DatabaseService({this.uid, this.artist});

  CollectionReference users = FirebaseFirestore.instance.collection("users");
  CollectionReference artistCollection = FirebaseFirestore.instance.collection("artists");
  final _firestore = FirebaseFirestore.instance;

  Stream<DocumentSnapshot<Map<String, dynamic>>> get userData {
    var _currentUser = FirebaseAuth.instance.currentUser!;
    return FirebaseFirestore.instance
        .collection("users")
        .doc(_currentUser.uid)
        .snapshots();
  }

  Future<void> addUser(String uid, String username, String email) {
    // Call the user's CollectionReference to add a new user
    return users
        .doc(uid)
        .set({
          "isAdmin": false,
          "uid": uid,
          "username": username,
          "email": email
        })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  Future<bool> findUsername(String username) async {
    final results = await users.where("username", isEqualTo: username).get();
    print(results.docs.isEmpty);
    return results.docs.isEmpty;
  }

  Future<bool> findEmail(String email) async {
    final results = await users.where("email", isEqualTo: email).get();
    print(results.docs.isEmpty);
    return results.docs.isEmpty;
  }

  Future<void> saveSong(PlatformFile? songFile, PlatformFile? songImage, String songName, String artistName) async {
    FirebaseStorage storage = FirebaseStorage.instance;
    File _songFile = File(songFile?.path ?? "");
    File _songImage = File(songImage?.path ?? "");

    String? directory = artistName;

    // Creating metadata from user input
    SettableMetadata metadata = SettableMetadata(
      cacheControl: "max-age=60",
      customMetadata: <String, String>{
        "songName": songName,
        "artists": artistName
      },
    );

    try {
      await storage.ref("${directory}/${songName}/${songName}").putFile(_songFile, metadata).then((_) =>  storage.ref("${directory}/${songName}/${songName}-Image").putFile(_songImage, metadata));
      await artistCollection
        .doc(artistName)
        .collection("songs")
        .doc(songName)
        .set({
          "songName": songName,
          "artists": artistName,
          "isFeatured": false,
          "isTrending": false
        })
        .then((value) => print("Song Added"))
        .catchError((error) => print("Failed to add song: $error"));
    } on FirebaseException catch (e) {
      print(e);
      // e.g, e.code == 'canceled'
    }
  }


  // Get song name from songs collection
  // Get song file using the song name

  SongModel? _songModel (SongModel? song) {
    if (song == null) {
      return null;
    }
    return SongModel(songName: song.songName, artist: song.artist, isTrending: song.isTrending, isFeatured: song.isFeatured);
  }

  List<SongModel> _messagesFromSnapshot(QuerySnapshot snapshot){
    return snapshot.docs.map((doc) {

      // String username = await getUsernameByUID(doc.data["uid"]);

      return SongModel(
        songName: doc["songName"],
        artist: doc["artists"],
        isTrending: doc["isTrending"],
        isFeatured: doc["isFeatured"]
        // text: doc.data["text"] ?? "",
        // username: username ?? "",
        // time: doc.data["time"] ?? "",
      );
    }).toList();
  }

  Stream<QuerySnapshot> get trendingSongs {
    return artistCollection
      .doc("Jeremy")
      .collection("songs")
      .where("isFeatured", isEqualTo: true)
      .snapshots();
  }


//   Stream readSomething(String docId){
//     return FirebaseFirestore.instance.collection("campdata").doc(docId).snapshots();
// } 

  Future<List<Reference>?> getSongImg(String artist, String songName) async {
    FirebaseStorage _storage = FirebaseStorage.instance;
    try {
      ListResult result = await _storage.ref().child("$artist").child("$songName").listAll();
      // print(result.getData());
      // print(result.items);
    
      // result.items.forEach((Reference ref) {
      //   print('Found file: ${ref.runtimeType}');
      // });
      if(result == null) {
        return null;
      }
      return result.items;
    } catch (e) {
      print(e);
    }
    // final List<Reference> allFiles = result.items;

    

    // return SongFiles(imageFile: _songImg, )
  }


  // Stream<QuerySnapshot<Map<String, dynamic>>> getFeaturedSongs(String artist) {
  //   print("click");
  //   Stream<QuerySnapshot<Map<String, dynamic>>> songSnapshot = artistCollection.doc("Jeremy").collection("songs").where("isFeatured", isEqualTo: true).snapshots();

  //   songSnapshot.map(_songModel);
    
  // }

  // Stream<QuerySnadypshot> get getSongs {
  //   // final songDocuments = await songs.get();
  //   // for (var document in songDocuments.docs) { 
  //   //   print(document.documentID);
  //   // }
  //   // print(results.toString());
  //   Stream songStream = songs.snapshots();
  //   return songStream;
  // }
}
