import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:pep/services/database.dart';
import 'package:pep/ui/shared/widgets/song_item.dart';
import 'package:pep/ui/shared/widgets/loading.dart';
import 'package:pep/ui/views/admin/admin.dart';
import 'package:pep/ui/views/profile/profile.dart';
import '../../shared/utils/constants.dart' as constants;

class Home extends HookWidget {
  @override
  Widget build(BuildContext context) {
    var _currentUser = FirebaseAuth.instance.currentUser!;
    var songArr = useState([]);

    useEffect(() {
      DatabaseService().getSongs().then((value) {
        value.shuffle();
        songArr.value = value;
      });

    }, []);

    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: DatabaseService(uid: _currentUser.uid).userData,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          return SafeArea(
            left: false,
            right: false,
            child: Scaffold(
              body: ScrollConfiguration(
                behavior: const ScrollBehavior(),
                child: ListView(
                  children: <Widget>[
                    buildAppBarRow(context, snapshot),
                    const SizedBox(height: 20.0),
                    // Feed
                    Center(
                      child: ElevatedButton(
                        style: TextButton.styleFrom(
                          elevation: 0,
                          backgroundColor: Colors.transparent
                        ),
                        onPressed: () {
                          DatabaseService().getSongs().then((value) {
                            value.shuffle();
                            songArr.value = value;
                          });
                        },
                        child: Row(
                          children: const [ 
                            Icon(Icons.refresh, size: 30, color: constants.Colors.mainColor),
                            Text("Your Feed", style:constants.ThemeText.secondaryTitleTextBlue),
                          ],
                        ),
                      ),
                    ),
                    buildFeed(context, songArr),
                  ],
                ),
              ),
            ));
        }
        return Loading();
      }
    );
  }

   buildAppBarRow(BuildContext context, snapshot) {
    return PreferredSize(
        preferredSize: Size(
          MediaQuery.of(context).size.width,
          60.0,
        ),
        child: Padding(
          padding: EdgeInsets.only(
              left: MediaQuery.of(context).size.width * 0.04, top: 20),
          child: Row(
            children: <Widget>[
              const Text("pep", style: constants.ThemeText.titleTextBlue),
              Padding(
                padding: EdgeInsets.only(left: snapshot.data!["isAdmin"] == false ? MediaQuery.of(context).size.width * 0.6 : MediaQuery.of(context).size.width * 0.5),
                child: Row(
                  children: [
                    snapshot.data!["isAdmin"] == false ? Container() : IconButton(
                      icon: const Icon(Icons.add),
                      iconSize: 30.0,
                      color: constants.Colors.darkGrey,
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => const AdminPage()));
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.person_rounded),
                      iconSize: 30.0,
                      color: constants.Colors.darkGrey,
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => const Profile()));
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  buildFeed(BuildContext context, ValueNotifier<List<dynamic>> songArr) {
    int _index = 0;

    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: PageView.builder(
        itemCount: songArr.value.length,
        controller: PageController(viewportFraction: 0.7),
        onPageChanged: (int index) => _index = index,
        itemBuilder: (_, i) {
          String artistName = songArr.value[i]["artists"];
          String songName = songArr.value[i]["songName"];
          var songImgLink = "https://firebasestorage.googleapis.com/v0/b/pepia-9b233.appspot.com/o/${artistName.toLowerCase()}%2F${songName}%2F${songName}-Image?alt=media";
          var songFileLink = "https://firebasestorage.googleapis.com/v0/b/pepia-9b233.appspot.com/o/${artistName.toLowerCase()}%2F${songName}%2F${songName}?alt=media";
          
          return SongItem(img: songImgLink, songFile: songFileLink, data: songArr.value[i],);
 
        },
      ),
    );

  }
}
