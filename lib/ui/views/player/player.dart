import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pep/models/comment.dart';
import 'package:pep/services/database.dart';
import 'package:pep/ui/shared/widgets/loading.dart';
import 'package:pep/ui/views/player/player_manager.dart';
import 'package:pep/ui/shared/utils/constants.dart' as constants;

class Player extends StatefulWidget {

  final String songName;
  final String artist;
  final String songFileLink;

  const Player({
    Key? key, 
    required this.songName, 
    required this.artist, 
    required this.songFileLink,
    }) : super(key: key);

  @override
  _PlayerState createState() => _PlayerState();
}

class _PlayerState extends State<Player> {
  late final PageManager _pageManager;

  final TextEditingController _commentController = TextEditingController();

  // Release memory from controllers
  @override
  void dispose() {
    _commentController.dispose();
    _pageManager.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _pageManager = PageManager(widget.songFileLink);
    
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: constants.Colors.mainColor,
      ),
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        left: false,
        right: false,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Row(
                children: [
                  Text("${widget.songName}", style: constants.ThemeText.titleTextBlack),
                ],
              ),
              const SizedBox(height: 5.0),
              Row(
                children: [
                  Text("${widget.artist}", style: constants.ThemeText.secondaryText),
                ],
              ),
              Row(
                children: const [
                  Padding(
                    padding: EdgeInsets.only(top: 15.0),
                    child: Text("Comments", style: constants.ThemeText.smallText)
                  )
                ],
              ),
              // Row(
              //   children: [
              //     Text("${likes}", style: constants.ThemeText.secondaryText),
              //   ],
              // ),
              // put song comments here
              Row(
                children: [
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 0.0),
                        child: Row(
                          children: [
                            FutureBuilder<List<CommentModel>>(
                              future: DatabaseService().getComments(widget.artist, widget.songName),
                              builder: (context, snap) {
                                switch (snap.connectionState) {
                                  case ConnectionState.waiting:
                                    return const Loading();
                                  default:
                                    if (snap.hasError) {
                                      return Text('Error: ${snap.error}');
                                    }
                                    else {
                                      return Column(
                                        children: [
                                          SizedBox(
                                            height: 290,
                                            width: MediaQuery.of(context).size.height * 0.42,
                                            child: ScrollConfiguration(
                                              behavior: const ScrollBehavior(),
                                              child: ListView.builder(
                                                itemCount: snap.data!.length,
                                                itemBuilder: (context, index) {
                                                  return ListTile(
                                                    leading: const Icon(Icons.person),
                                                    title: Text("${snap.data![index].author}"),
                                                    subtitle: Text("${snap.data![index].comment}"),
                                                  );
                                                }
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context).size.width * 0.9,
                                            height: MediaQuery.of(context).size.width * 0.4,
                                            child: Focus(
                                              child: TextFormField(
                                                maxLines: 3,
                                                maxLength: 100,
                                                controller: _commentController,
                                                style: const TextStyle(
                                                  fontSize: 15
                                                ),
                                                decoration: InputDecoration(
                                                  floatingLabelBehavior: FloatingLabelBehavior.never,
                                                  labelText: "Type your comment here",
                                                  filled: true,
                                                  fillColor: constants.Colors.lightGrey,
                                                  border: OutlineInputBorder(
                                                      borderSide: BorderSide.none,
                                                      borderRadius: BorderRadius.circular(20.0)),
                                                ),
                                              ),
                                            ),
                                          ),

                                          Column(
                                            children: [
                                              SizedBox(
                                                height: 45.0,
                                                width: 120.0,
                                                child: TextButton(
                                                  style: constants.Button.textButton,
                                                  child: const Text(
                                                    "Comment",
                                                    style: TextStyle(color: Colors.white),
                                                  ),
                                                  onPressed: () async {
                                                    DatabaseService().addComment(widget.artist, widget.songName, _commentController.text);
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                        ]
                                      );
                                    }
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),

              const Spacer(),
              ValueListenableBuilder<ProgressBarState>(
                valueListenable: _pageManager.progressNotifier,
                builder: (_, value, __) {
                  return ProgressBar(
                    progress: value.current,
                    buffered: value.buffered,
                    total: value.total,
                    onSeek: _pageManager.seek,
                  );
                },
              ),
              ValueListenableBuilder<ButtonState>(
                valueListenable: _pageManager.buttonNotifier,
                builder: (_, value, __) {
                  switch (value) {
                    case ButtonState.loading:
                      return Container(
                        margin: const EdgeInsets.all(8.0),
                        width: 32.0,
                        height: 32.0,
                        child: const CircularProgressIndicator(),
                      );
                    case ButtonState.paused:
                      return IconButton(
                        icon: const Icon(Icons.play_arrow),
                        iconSize: 32.0,
                        onPressed: _pageManager.play,
                      );
                    case ButtonState.playing:
                      return IconButton(
                        icon: const Icon(Icons.pause),
                        iconSize: 32.0,
                        onPressed: _pageManager.pause,
                      );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}