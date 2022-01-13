import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pep/services/auth.dart';
import 'package:pep/services/database.dart';
import 'package:pep/ui/shared/widgets/loading.dart';
import 'package:pep/ui/shared/utils/constants.dart' as constants;

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    final AuthService authService = AuthService();
    var _currentUser = FirebaseAuth.instance.currentUser!;

    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: DatabaseService(uid: _currentUser.uid).userData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            return SafeArea(
              child: Scaffold(
                appBar: AppBar(
                  elevation: 0,
                  backgroundColor: constants.Colors.mainColor,
                ),
                body: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Row(
                        children: const [
                          Text(
                            "Your Profile",
                            style: constants.ThemeText.titleTextBlue,
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Row(
                        children: const [
                          Text(
                            "Email",
                            style: constants.ThemeText.secondaryTitleTextBlue,
                          )
                        ],
                      ),
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                          textStyle: const TextStyle(fontSize: 20),
                          backgroundColor: Colors.black),
                      onPressed: () {
                        authService.signOut();
                        Navigator.pop(context);
                      },
                      child: const Text('sign out'),
                    ),
                  ],
                ),
                // body: Column(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     Text("${snapshot.data!["email"]}"),
                //     TextButton(
                //       style: TextButton.styleFrom(
                //           textStyle: const TextStyle(fontSize: 20),
                //           backgroundColor: Colors.black),
                //       onPressed: () {
                //         authService.signOut();
                //         Navigator.pop(context);
                //       },
                //       child: const Text('sign out'),
                //     ),
                //   ],
                // ),
              ),
            );
          }
          return Loading();
        });
  }
}
