import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

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

  Stream<QuerySnapshot<Map<String, dynamic>>> get artists {
    return FirebaseFirestore.instance.collection("artists").where("isArtist", isEqualTo: true).snapshots();
    
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

  Future<void> addArtist(String artistName) async {
    await artistCollection.doc("artists").update({"artists": FieldValue.arrayUnion([artistName.toLowerCase()]) });
    await artistCollection.doc(artistName.toLowerCase()).set({ "isArtist": true });
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

    String? directory = artistName.toLowerCase();

    // Creating metadata from user input
    SettableMetadata metadata = SettableMetadata(
      cacheControl: "max-age=60",
      customMetadata: <String, String>{
        "songName": songName,
        "artists": artistName
      },
    );

    // Try to create the new files, saving the audio and imgage file
    // Also add the information into database as documents
    try {
      await addArtist(artistName);
      await storage.ref("${directory}/${songName}/${songName}").putFile(_songFile, metadata).then((_) =>  storage.ref("${directory}/${songName}/${songName}-Image").putFile(_songImage, metadata));
      await artistCollection
        .doc(directory)
        .collection("songs")
        .doc(songName)
        .set({
          "songName": songName,
          "artists": artistName,
          "likes": 0
          // "isFeatured": false,
          // "isTrending": false,
          // "random": randomNum
        })
        .then((value) => print("Song Added"))
        .catchError((error) => print("Failed to add song: $error"));
    } on FirebaseException catch (e) {
      print(e);
      
    }
  }


  // List<SongModel> _songFromSnapshot(QueryDocumentSnapshot snapshot){
  //   return snapshot.map((doc) {
  //     return SongModel(
  //       songName: doc["songName"],
  //       artist: doc["artists"],
  //       isTrending: doc["isTrending"],
  //       isFeatured: doc["isFeatured"],
  //       random: doc["random"]
  //     );
  //   }).toList();
  // }


  // Future<void> getRanArtist() async {

  //   artistCollection.doc("artists").get().then((value) {
  //     var artistArr = value.get("artists");
  //     var arrSize = artistArr.length - 1;
      
  //     int min = 0;
  //     int max = arrSize;
  //     num randomNum = Random().nextInt(max - min) + min;

  //   });
  

  // }

  // Future<List?> getAllArtists() async {
  //   try {
  //     artistCollection.doc("artists").get().then((value) {
  //       var artistArr = value.get("artists");
  //       // print(artistArr);
  //       return artistArr;
  //     });
  //   } catch (e) {
  //     return null;
  //   }
  // }

  // Stream<QuerySnapshot> get trendingSongs {
  //   return artistCollection
  //     .doc("Jeremy")
  //     .collection("songs")
  //     .where("isFeatured", isEqualTo: true)
  //     .snapshots();
  // }


//   Stream readSomething(String docId){
//     return FirebaseFirestore.instance.collection("campdata").doc(docId).snapshots();
// } 

  Future<List<Reference>?> getSongImg(String artist, String songName) async {
    FirebaseStorage _storage = FirebaseStorage.instance;
    try {
      ListResult result = await _storage.ref().child("$artist").child("$songName").listAll();
      if(result == null) {
        return null;
      }
      return result.items;
    } catch (e) {
      print(e);
    }

  }

  // Future<QuerySnapshot<Map<String, dynamic>>?>

  Future<List> getSongs() async {
    var songArr = [];
    await FirebaseFirestore.instance.collectionGroup("songs").get().then((doc) {
      // print(doc.docs[0].data());
      // print(doc.docs.length);

      for (var i=0; i<doc.docs.length; i++) {
        songArr.add(doc.docs[i].data());
      }
      // print(songArr);
      
    });
    return songArr;
  }

  // Future<QuerySnapshot<Map<String, dynamic>>?> getSongs() async {
  //   var songArr = [];
  //   await FirebaseFirestore.instance.collectionGroup("songs").get().then((doc) {
  //     // print(doc.docs[0].data());
  //     // print(doc.docs.length);

  //     // for (var i=0; i<doc.docs.length; i++) {
  //     //   songArr.add(doc.docs[i].data());
  //     // }
  //     // print(songArr);
  //     print(doc);
  //     return doc;
  //   });
  //   // return songArr;
  // }
}
