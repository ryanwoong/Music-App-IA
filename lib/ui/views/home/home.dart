import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:pep/services/database.dart';
import 'package:pep/ui/shared/widgets/carousel_item.dart';
import 'package:pep/ui/shared/widgets/loading.dart';
import 'package:pep/ui/views/admin/admin.dart';
import 'package:pep/ui/views/profile/profile.dart';
import '../../shared/utils/constants.dart' as constants;
import '../../shared/utils/ads.dart';

class Home extends HookWidget {
  @override
  Widget build(BuildContext context) {
    var _currentUser = FirebaseAuth.instance.currentUser!;
    // var songArr;
    var songArr = useState([]);

    useEffect(() {
      DatabaseService().getSongs().then((value) {
        print("test $value ");
        songArr.value = value;
        // print(value);
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
              body: Padding(
                  padding: const EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
                  child: ScrollConfiguration(
                    behavior: const ScrollBehavior(),
                    child: ListView(
                      children: <Widget>[
                        buildAppBarRow(context, snapshot),
                        const SizedBox(height: 20.0),
                        // buildBannerRow(context),
                        // const SizedBox(height: 20.0),

                        // Feed
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Row(
                            children: const [
                              Text("Your Feed", style:constants.ThemeText.secondaryTitleTextBlue),
                            ],
                          ),
                        ),
                        buildFeed(context, songArr),
    
                        // // Featured Row
                        // Padding(
                        //   padding: const EdgeInsets.only(top: 10),
                        //   child: Row(
                        //     children: [
                        //       const Text("Featured", style:constants.ThemeText.secondaryTitleTextBlue),
                        //       Padding(
                        //         padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.45),
                        //         child: TextButton(
                        //           onPressed: () {
                        //             print("pressed");
                        //           },
                        //           child: const Text("more",
                        //               style: constants.ThemeText.secondaryText),
                        //         ),
                        //       ),
                        //     ],
                        //   ),
                        // ),
                        // buildFeaturedRow(context),
    
                        // // Trending Row
                        // Padding(
                        //   padding: const EdgeInsets.only(top: 10),
                        //   child: Row(
                        //     children: [
                        //       const Text("Trending Now",style: constants.ThemeText.secondaryTitleTextBlue),
                        //       Padding(
                        //         padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.3),
                        //         child: TextButton(
                        //           onPressed: () {
                        //             print("pressed");
                        //           },
                        //           child: const Text("more",
                        //               style: constants.ThemeText.secondaryText),
                        //         ),
                        //       ),
                        //     ],
                        //   ),
                        // ),
                        // buildFeaturedRow(context),
                      ],
                    ),
                  )),
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
                        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => AdminPage()));
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.person_rounded),
                      iconSize: 30.0,
                      color: constants.Colors.darkGrey,
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Profile()));
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  buildBannerRow(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height / 3.5,
        width: MediaQuery.of(context).size.width,
        child: ScrollConfiguration(
          behavior: ScrollBehavior(),
          child: ListView.builder(
            primary: false,
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: ads == null ? 0 : ads.length,
            itemBuilder: (BuildContext context, int index) {
              Map ad = ads[index];

              return Container();
              // return Padding(
              //   padding: const EdgeInsets.only(right: 10.0),
              //   child: BannerItem(
              //       title: ad["item"], desc: ad["desc"], img: ad["img"]),
              // );
            },
          ),
        ));
  }

  buildFeed(BuildContext context, ValueNotifier<List<dynamic>> songArr) {
    int _index = 0;

    return Container(
      height: MediaQuery.of(context).size.height / 2,
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
