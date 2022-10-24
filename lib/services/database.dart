import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:pep/models/comment.dart';


class DatabaseService {
  final String? uid;
  final String? artist;

  DatabaseService({this.uid, this.artist});

  CollectionReference users = FirebaseFirestore.instance.collection("users");
  CollectionReference artistCollection = FirebaseFirestore.instance.collection("artists");

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

  Future<void> upvote(String artistName, String songName) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final uid = user?.uid;

    await artistCollection.doc(artistName.toLowerCase()).collection("songs").doc(songName).get().then((doc) {
      List upvotes = doc["upvotes"];
      List downvotes = doc["downvotes"];

      // If user already has upvoted this song
      if (upvotes.contains(uid)) {
        return;
      // If user has downvoted, then delete and add upvote
      } if (downvotes.contains(uid)) {
        artistCollection.doc(artistName.toLowerCase()).collection("songs").doc(songName).update({"downvotes": FieldValue.arrayRemove([uid]) });
        artistCollection.doc(artistName.toLowerCase()).collection("songs").doc(songName).update({"upvotes": FieldValue.arrayUnion([uid]) });
      // If none of above conditions are true then just add upvote
      } else {
        artistCollection.doc(artistName.toLowerCase()).collection("songs").doc(songName).update({"upvotes": FieldValue.arrayUnion([uid]) });
      }
    });
  }

  Future<void> downvote(String artistName, String songName) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final uid = user?.uid;
    
    await artistCollection.doc(artistName.toLowerCase()).collection("songs").doc(songName).get().then((doc) {
      List upvotes = doc["upvotes"];
      List downvotes = doc["downvotes"];

      // If user already has downvoted this song
      if (downvotes.contains(uid)) {
        return;
      // If user has upvoted, then delete and add downvote
      } if (upvotes.contains(uid)) {
        artistCollection.doc(artistName.toLowerCase()).collection("songs").doc(songName).update({"upvotes": FieldValue.arrayRemove([uid]) });
        artistCollection.doc(artistName.toLowerCase()).collection("songs").doc(songName).update({"downvotes": FieldValue.arrayUnion([uid]) });
      // If none of above conditions are true then just add upvote
      } else {
        artistCollection.doc(artistName.toLowerCase()).collection("songs").doc(songName).update({"downvotes": FieldValue.arrayUnion([uid]) });
      }
    });
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

  void addComment(String artistName, String songName, String comment) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final uid = user?.uid;
    String? username;
    await getUsername(uid).then((val) => username = val);
    artistCollection.doc(artistName.toLowerCase()).collection("songs").doc(songName).collection("comments").add({
      "author": username,
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

    // Try to create the new files, saving the audio and image file
    // Also add the information into database as documents
    try {
      await addArtist(artistName);
      await storage.ref("${directory}/${songName}/${songName}").putFile(_songFile, metadata).then((_) =>  storage.ref("${directory}/${songName}/${songName}-Image")
      .putFile(_songImage, metadata));
      await artistCollection
        .doc(directory)
        .collection("songs")
        .doc(songName)
        .set({
          "songName": songName,
          "artists": artistName,
          "upvotes": [],
          "downvotes": []
        })
        .then((value) {
        });
    } on FirebaseException catch (e) {
      return;
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

  Future<String> getUsername (String? uid) async {
    String username = "";
    await users.doc(uid).get().then((doc) => {
      username = doc["username"]
    });
    return username;
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

  Future<List<Comment>> getComments(String artistName, String songName) async {
    List<Comment> comments = [];
    await artistCollection.doc(artistName.toLowerCase()).collection("songs").doc(songName).collection("comments").get().then((doc) {
      for (var i=0; i<doc.docs.length; i++) {
        comments.add(Comment(author: doc.docs[i].data()["author"], comment: doc.docs[i].data()["comment"]));
      }
    });

    return comments;
  }
}
