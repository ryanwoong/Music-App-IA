import 'package:flutter/material.dart';
import 'package:pep/ui/shared/utils/constants.dart' as constants;
import 'package:pep/ui/views/player/player.dart';

class SongItem extends StatefulWidget {
  final String img;
  final String songFile;
  final Map data;

  const SongItem(
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
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.5,
              width: MediaQuery.of(context).size.height / 3,
              child: Card(
                elevation: 0,
                semanticContainer: false,
                clipBehavior: Clip.antiAlias,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0)
                ),
                child: InkWell(
                  splashColor: constants.Colors.lightGrey,
                  onTap: () {
                    
                    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Player(songName: widget.data["songName"], artist: widget.data["artists"], songFileLink: widget.songFile, upvotes: widget.data["upvotes"], downvotes: widget.data["downvotes"],)));
                  },
                  child: Image.network(widget.img, fit: BoxFit.cover),
                ),
              ),
            ),
            Text("${widget.data["songName"]}", style: constants.ThemeText.smallTextBoldBlack),
            Text("by ${widget.data["artists"]}")
          ],
        );
      
  }
}
