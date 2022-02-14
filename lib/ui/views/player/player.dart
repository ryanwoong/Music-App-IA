import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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
  late int likes = 0;

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
    // likes = 3;
    // WidgetsBinding.instance?.addPostFrameCallback((_) {
    //   DatabaseService().getLikes(widget.artist, widget.songName);
    // });
    DatabaseService().getLikes(widget.artist, widget.songName).then((value)  {
      likes = value;
      setState(() {});
    });
    _pageManager = PageManager(widget.songFileLink);
    
  }

  @override
  Widget build(BuildContext context) {

    // Future<int> likes = await DatabaseService().getLikes(widget.artist, widget.songName);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: constants.Colors.mainColor,
      ),
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
                children: [
                  Text("${likes}", style: constants.ThemeText.secondaryText),
                ],
              ),
              // put song comments here
              Row(
                children: [
                  FutureBuilder(
                    future: FirebaseFirestore.instance.collection("artists").doc(widget.artist.toLowerCase()).collection("songs").doc(widget.songName).collection("comments").get(),
                    builder: (_, AsyncSnapshot snapshot) {
           
                       return Container(
                          child: Column(
                            children: [
                              Text(snapshot.hasData ? "" : "No comments."),
                              Padding(
                                padding: const EdgeInsets.only(left: 0.0),
                                child: Row(
                                  children: [
                                    FutureBuilder(
                                      future: DatabaseService().getComments(widget.artist, widget.songName),
                                      builder: (context, snapshot) {
                                        switch (snapshot.connectionState) {
                                          case ConnectionState.waiting:
                                            return Loading();
                                          default:
                                            if (snapshot.hasError) {
                                              return Text('Error: ${snapshot.error}');
                                            }
                                            else {
                                              print(snapshot.data);
                                              return Text("${snapshot.data}");
                                              // return SizedBox(
                                              //   height: 450,
                                              //   width: 400,
                                              //   child: ListView.builder(
                                              //     itemCount: 20,
                                              //     itemBuilder: (context, index) {
                                              //       print(snapshot.data);
                                              //       return ListTile(
                                              //         leading: Icon(Icons.list),
                                              //         title: Text("test")
                                              //       );
                                              //     }
                                              //   ),
                                              // );
                                            }
                                              
                                        }
                                      },
                                    ),

                                    // SizedBox(
                                    //   width: MediaQuery.of(context).size.width * 0.9,
                                    //   height: MediaQuery.of(context).size.width * 0.4,
                                    //   child: Focus(
                                    //     child: TextFormField(
                                    //       maxLines: 3,
                                    //       maxLength: 100,
                                    //       controller: _commentController,
                                    //       style: const TextStyle(
                                    //         fontSize: 15
                                    //       ),
                                    //       decoration: InputDecoration(
                                    //         floatingLabelBehavior: FloatingLabelBehavior.never,
                                    //         labelText: "Artist",
                                    //         filled: true,
                                    //         fillColor: constants.Colors.lightGrey,
                                    //         border: OutlineInputBorder(
                                    //             borderSide: BorderSide.none,
                                    //             borderRadius: BorderRadius.circular(20.0)),
                                    //       ),
                                    //     ),
                                    //   ),
                                    // ),
                                  ],
                                ),
                              ),
                              Padding(
                              padding: const EdgeInsets.only(left: 20.0),
                              child: Row(
                                children: [
                                  SizedBox(
                                    height: 45.0,
                                    width: 120.0,
                                    child: TextButton(
                                      style: constants.Button.textButton,
                                      child: const Text(
                                        "Add Song",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      onPressed: () async {
                                        DatabaseService().addComment(widget.artist, widget.songName, _commentController.text);
                                      },
                                    ),
                                  ),
                                ],
                              )
                            ),
                            ],
                          ),
                        );
                      // if (snapshot.hasData) {
                      //   return Container(
                      //     width: 250,
                      //     height: 400,
                      //     child: ListView.builder(
                      //       itemCount: 10,
                      //       itemBuilder: (context, index) {
                      //         // print("TEST ${snapshot.data["comments"]}");
                      //         // return Text("${snapshot.data["comments"]}");
                      //        return 
                      //       },
                      //     ),
                      //   );
                      // }
                      // if (snapshot.hasError) {
                      //   print('SNAPSHOT ERROR: ${snapshot.error}');
                      //   return Text('${snapshot.error}');
                      // } else {
                      //   return Container(
                      //     child: Column(
                      //       children: [
                      //         const Text("There are no comments, be the first one!"),
                      //         Padding(
                      //           padding: const EdgeInsets.only(left: 0.0),
                      //           child: Row(
                      //             children: [
                      //               SizedBox(
                      //                 width: MediaQuery.of(context).size.width * 0.9,
                      //                 height: MediaQuery.of(context).size.width * 0.4,
                      //                 child: Focus(
                      //                   child: TextFormField(
                      //                     maxLines: 3,
                      //                     maxLength: 100,
                      //                     controller: _commentController,
                      //                     style: const TextStyle(
                      //                       fontSize: 15
                      //                     ),
                      //                     decoration: InputDecoration(
                      //                       floatingLabelBehavior: FloatingLabelBehavior.never,
                      //                       labelText: "Artist",
                      //                       filled: true,
                      //                       fillColor: constants.Colors.lightGrey,
                      //                       border: OutlineInputBorder(
                      //                           borderSide: BorderSide.none,
                      //                           borderRadius: BorderRadius.circular(20.0)),
                      //                     ),
                      //                   ),
                      //                 ),
                      //               ),
                      //             ],
                      //           ),
                      //         ),
                      //         Padding(
                      //         padding: const EdgeInsets.only(left: 20.0),
                      //         child: Row(
                      //           children: [
                      //             SizedBox(
                      //               height: 45.0,
                      //               width: 120.0,
                      //               child: TextButton(
                      //                 style: constants.Button.textButton,
                      //                 child: const Text(
                      //                   "Add Song",
                      //                   style: TextStyle(color: Colors.white),
                      //                 ),
                      //                 onPressed: () async {
                      //                   DatabaseService().addComment(widget.artist, widget.songName, _commentController.text);
                      //                 },
                      //               ),
                      //             ),
                      //           ],
                      //         )
                      //       ),
                      //       ],
                      //     ),
                      //   );
                      }
                    // },
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