import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseService {
  final String? uid;

  DatabaseService({this.uid});

  CollectionReference users = FirebaseFirestore.instance.collection("users");

  Stream<DocumentSnapshot<Map<String, dynamic>>> get userData{
    var _currentUser = FirebaseAuth.instance.currentUser!;
    return FirebaseFirestore.instance.collection("users").doc(_currentUser.uid).snapshots();
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
}
