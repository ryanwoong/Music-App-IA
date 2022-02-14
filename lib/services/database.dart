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
  // final _firestore = FirebaseFirestore.instance;

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

  void addComment(String artistName, String songName, String comment) {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final uid = user?.uid;

    artistCollection.doc(artistName.toLowerCase()).collection("songs").doc(songName).collection("comments").add({
      "author": uid,
      "comment": comment
    });
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
          "likes": 0,
        })
        .then((value) {
          // print("Song Added");
        })
        .catchError((error) => print("Failed to add song: $error"));
    } on FirebaseException catch (e) {
      // print(e);
    }
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

  Future<List> getSongs() async {
    var songArr = [];
    await FirebaseFirestore.instance.collectionGroup("songs").get().then((doc) {
      for (var i=0; i<doc.docs.length; i++) {
        songArr.add(doc.docs[i].data());
      }
      
    });
    return songArr;
  }

  Future<int> getLikes(String artistName, String songName) async {
    int likes = 0;
    await artistCollection.doc(artistName.toLowerCase()).collection("songs").doc(songName).get().then((snapshot) {
      likes = snapshot.data()!["likes"];
    });

    return likes;
  }

  Future<List> getComments(String artistName, String songName) async {
    List comments = [];
    await artistCollection.doc(artistName.toLowerCase()).collection("songs").doc(songName).collection("comments").get().then((doc) {
      comments = doc.docs;
    });

    return comments;
  }
}
