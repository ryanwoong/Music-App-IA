import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pep/ui/shared/utils/constants.dart' as constants;
import 'package:pep/ui/views/player/player.dart';

class SongItem extends StatefulWidget {
  // ? is null - needed?
  final String img;
  final String songFile;
  // final List data;
  final Map data;
  // num can use 9 and 9.0

  SongItem(
      {Key? key,
      required this.img,
      required this.songFile,
      required this.data
      })
      : super(key: key);

  @override
  _SongItemState createState() => _SongItemState();
}

class _SongItemState extends State<SongItem> {

  @override
  Widget build(BuildContext context) {
        return Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.5,
              width: MediaQuery.of(context).size.height / 3,
              child: Card(
                elevation: 0,
                semanticContainer: false,
                clipBehavior: Clip.antiAlias,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0)),
                child: InkWell(
                  splashColor: constants.Colors.lightGrey,
                  onTap: () {
                    // print("data ${widget.data.data()["artists"]}");
                    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Player(songName: widget.data["songName"], artist: widget.data["artists"], songFileLink: widget.songFile)));
                  },
                  child: Image.network("${widget.img}", fit: BoxFit.cover),
                ),
              ),
            ),
            // Text("${widget.data.data()["songName"]}", style: constants.ThemeText.smallTextBoldBlack),
            // Text("by ${widget.data.data()["artists"]}")
          ],
        );
      
  }
}
