// ignore_for_file: file_names

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pep/ui/shared/widgets/banner_item.dart';
import 'package:pep/ui/shared/widgets/carousel.dart';
import '../shared/utils/constants.dart' as constants;
import '../shared/utils/ads.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
        child: ListView(
          children: <Widget>[
            const SizedBox(height: 20.0),
            buildBannerRow(context),
            const SizedBox(height: 20.0),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Row(
                children: <Widget>[
                  RichText(
                      text: TextSpan(
                      style: constants.ThemeText.secondaryTitleText,
                        children: <TextSpan>[
                          TextSpan(
                            text: "Featured Songs",
                          ),
                          TextSpan(
                            text: "more",
                            style: constants.ThemeText.secondaryText,
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                print("tapped");
                              }
                          )
                        ],
                      )
                  )
                         
                  // Text("Featured Releases", style: constants.ThemeText.secondaryTitleText),
                  // Padding(
                  //   padding: EdgeInsets.only(left: 110),
                  //   child: Text("more", style: constants.ThemeText.secondaryText),
                  // )
                ],
              ),
            ),
            buildFeaturedRow(context),
            const Padding(
              padding: EdgeInsets.only(top: 10),
              child: Text("Trending Now",
                  style: constants.ThemeText.secondaryTitleText),
            ),
            buildFeaturedRow(context),
          ],
        ),
      ),
    );
  }
}

buildAppBar(BuildContext context) {
  return PreferredSize(
    preferredSize: Size(
      MediaQuery.of(context).size.width,
      60.0,
    ),
    child: Padding(
        padding: EdgeInsets.only(
          top: 50.0,
          left: 20.0,
        ),
        child: Row(
          children: <Widget>[
            Text("pep", style: constants.ThemeText.titleText),
            IconButton(
              padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width / 1.5),
              icon: const Icon(Icons.person_rounded),
              iconSize: 30.0,
              color: constants.Colors.darkGrey,
              onPressed: () {},
            ),
          ],
        )),
  );
}

buildBannerRow(BuildContext context) {
  return Container(
    height: MediaQuery.of(context).size.height / 3.5,
    width: MediaQuery.of(context).size.width,
    child: ListView.builder(
      primary: false,
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      itemCount: ads == null ? 0 : ads.length,
      itemBuilder: (BuildContext context, int index) {
        Map ad = ads[index];

        return Padding(
          padding: const EdgeInsets.only(right: 10.0),
          child:
              BannerItem(title: ad["item"], desc: ad["desc"], img: ad["img"]),
        );
      },
    ),
  );
}

buildFeaturedRow(BuildContext context) {
  return Container(
    height: MediaQuery.of(context).size.height / 3.5,
    width: MediaQuery.of(context).size.width,
    child: ListView.builder(
      primary: false,
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      itemCount: ads == null ? 0 : ads.length,
      itemBuilder: (BuildContext context, int index) {
        Map ad = ads[index];

        return Padding(
          padding: const EdgeInsets.only(right: 10.0),
          child: BannerItem(
              title: ad["item"],
              desc: ad["desc"],
              img: ad["img"],
              height: 0.6,
              width: 0.4),
        );
      },
    ),
  );
}
