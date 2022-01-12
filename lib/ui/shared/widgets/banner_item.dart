import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pep/ui/shared/utils/constants.dart' as constants;
import 'package:pep/ui/views/player/player.dart';

class BannerItem extends StatefulWidget {
  // ? is null - needed?
  final String? title;
  final String? desc;
  final String img;
  final String songFile;
  final QueryDocumentSnapshot<Map<String, dynamic>> data;
  // num can use 9 and 9.0
  final num height;
  final num width;

  BannerItem(
      {Key? key,
      required this.title,
      required this.desc,
      required this.img,
      required this.songFile,
      required this.data,
      this.height = 1.0,
      this.width = 0.8})
      : super(key: key);

  @override
  _BannerItemState createState() => _BannerItemState();
}

class _BannerItemState extends State<BannerItem> {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.25,
          width: 150,
          child: Card(
            elevation: 0,
            semanticContainer: false,
            clipBehavior: Clip.antiAlias,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0)),
            child: InkWell(
              splashColor: constants.Colors.lightGrey,
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Player(songFileLink: widget.songFile)));
              },
              child: Image.network("${widget.img}", fit: BoxFit.cover),
            ),
          ),
        ));
  }
}
