import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:pep/models/song.dart';
import 'package:pep/services/database.dart';
import 'package:pep/services/file.dart';
import 'package:pep/ui/shared/widgets/loading.dart';
import '../../shared/utils/constants.dart' as constants;

class AdminPage extends StatefulWidget {
  const AdminPage({Key? key}) : super(key: key);

  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  String _currentValue = "Add Song";
  String? _error = "";
  Color? _errorColor = constants.Colors.error;
  PlatformFile? _songFile = null;
  PlatformFile? _songImage = null;
  bool _addSong = true;

  final TextEditingController _songNameController = TextEditingController();
  final TextEditingController _songArtistController = TextEditingController();

  // Release memory that is stored by the controllers
  @override
  void dispose() {
    _songNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: SafeArea(
        left: false,
        right: false,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: constants.Colors.mainColor,
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    const Text(
                      "Select:",
                      style: constants.ThemeText.smallText,
                    ),
                    ButtonTheme(
                      alignedDropdown: true,
                      child: DropdownButton<String>(
                        value: _currentValue,
                        style:
                            const TextStyle(color: constants.Colors.darkGrey),
                        underline: Container(
                          color: Colors.transparent,
                        ),
                        onChanged: (String? newValue) {
                          setState(() {
                            // Ensure that state value doesn't change again when user selects same element
                            if (_currentValue != newValue) {
                              _addSong = !_addSong;
                            }
                            _currentValue = newValue!;
                          });
                        },
                        items: <String>["Add Song", "Remove Song"]
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: constants.ThemeText.smallText,
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20.0),
              Padding(
                  padding: const EdgeInsets.all(25.0),
                  // child: _addSong ? buildAddSong(context, _error) : buildRemoveSong(context),
                  child: _addSong
                      ? Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(left: 5.0),
                              child: Row(
                                children: const <Widget>[
                                  Text("Add Song",
                                      style: constants.ThemeText.titleTextBlue),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20.0),
                            Padding(
                              padding: const EdgeInsets.only(left: 5.0),
                              child: Row(
                                children: <Widget>[
                                  Text(
                                    "$_error",
                                    style: TextStyle(
                                        color: _errorColor,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20.0),
                            Padding(
                              padding: const EdgeInsets.only(left: 20.0),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.7,
                                    child: Focus(
                                      child: TextFormField(
                                        controller: _songNameController,
                                        decoration: InputDecoration(
                                          floatingLabelBehavior:
                                              FloatingLabelBehavior.never,
                                          labelText: "Song Name",
                                          filled: true,
                                          fillColor: constants.Colors.lightGrey,
                                          border: OutlineInputBorder(
                                              borderSide: BorderSide.none,
                                              borderRadius:
                                                  BorderRadius.circular(20.0)),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20.0),
                            Padding(
                              padding: const EdgeInsets.only(left: 20.0),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.7,
                                    child: Focus(
                                      child: TextFormField(
                                        controller: _songArtistController,
                                        decoration: InputDecoration(
                                          floatingLabelBehavior:
                                              FloatingLabelBehavior.never,
                                          labelText: "Artist",
                                          filled: true,
                                          fillColor: constants.Colors.lightGrey,
                                          border: OutlineInputBorder(
                                              borderSide: BorderSide.none,
                                              borderRadius:
                                                  BorderRadius.circular(20.0)),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20.0),
                            Padding(
                              padding: const EdgeInsets.only(left: 5.0),
                              child: Row(
                                children: <Widget>[
                                  TextButton.icon(
                                    icon: const Icon(
                                      Icons.search,
                                      color: constants.Colors.darkGrey,
                                    ),
                                    label: const Text("Select an audio file",
                                        style: constants.ThemeText.smallText),
                                    onPressed: () async {
                                      // Get the file and return FileStructure and update the state of the variables
                                      SongFile result =
                                          await FileService().pickAudioFile();
                                      // print("FILE: ${result.getSongFile()}");
                                      // print("MESSAGE: ${result.getStatusMessage()}");
                                      String? _statusMessage =
                                          result.getStatusMessage();
                                      setState(() {
                                        if (_statusMessage == "File OK") {
                                          _errorColor = constants.Colors.success;
                                        } else {
                                          _errorColor = constants.Colors.error;
                                        }
                                        _error = "$_statusMessage";
                                        _songFile = result.getSongFile();
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 20.0),
                              child: Row(
                                children: <Widget>[
                                  Text(
                                    "${_songFile?.name ?? ""}",
                                    style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: constants.Colors.darkGrey),
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(height: 20.0),
                            Padding(
                              padding: const EdgeInsets.only(left: 5.0),
                              child: Row(
                                children: <Widget>[
                                  TextButton.icon(
                                    icon: const Icon(
                                      Icons.search,
                                      color: constants.Colors.darkGrey,
                                    ),
                                    label: const Text("Select an image file",
                                        style: constants.ThemeText.smallText),
                                    onPressed: () async {
                                      // Get the file and return FileStructure and update the state of the variables
                                      SongImage result =
                                          await FileService().pickImageFile();
                                      // print("FILE: ${result.getSongFile()}");
                                      // print("MESSAGE: ${result.getStatusMessage()}");
                                      String? _statusMessage = result.getStatusMessage();
                                      setState(() {
                                        if (_statusMessage == "File OK") {
                                          _errorColor = constants.Colors.success;
                                        } else {
                                          _errorColor = constants.Colors.error;
                                        }
                                        _error = "$_statusMessage";
                                        _songImage = result.getImageFile();
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 20.0),
                              child: Row(
                                children: <Widget>[
                                  Text(
                                    "${_songImage?.name ?? ""}",
                                    style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: constants.Colors.darkGrey),
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(height: 20.0),
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
                                      onPressed: () {
                                        DatabaseService().saveSong(
                                            _songFile,
                                            _songImage,
                                            _songNameController.text,
                                            _songArtistController.text);
                                      },
                                    ),
                                  ),
                                ],
                              )
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
                                        "click",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      onPressed: () async {
                                        // Future<List<Reference>?> items = DatabaseService().getSongImg("Jeremy", "Summer");
                                        // DatabaseService().getRanArtist();
                                        // DatabaseService().getAllSongs();
                                       
                                       
                                      },
                                    ),
                                  ),
                                ],
                              )
                            ),
                          ],
                        )
                      : buildRemoveSong(context))
            ],
          ),
        ),
      ),
    );
  }
}

// buildAddSong(BuildContext context, error) {
//   final TextEditingController _songTitleController = TextEditingController();
//   var result;

//   return Container(
//     child: Column(
//       children: <Widget>[
//         Padding(
//           padding: const EdgeInsets.only(left: 20.0),
//           child: Row(
//             children: const <Widget>[
//               Text("Add Song", style: constants.ThemeText.titleText),
//             ],
//           ),
//         ),
//         const SizedBox(height: 20.0),
//         IconButton(
//             icon: Icon(Icons.search),
//             onPressed: () async {error = await FileService().pickFile();
//               print(error);
//               // final results = showSearch(context: context, delegate: SongSearch());
//               // print("Result: ${results.toString()}");
//             }),
//         // SizedBox(
//         //   width: MediaQuery.of(context).size.width * 0.85,
//         //   child: Padding(
//         //     padding: const EdgeInsets.only(left: 10.0),
//         //     child: TextField(
//         //       controller: _songTitleController,
//         //       decoration: InputDecoration(
//         //         floatingLabelBehavior: FloatingLabelBehavior.never,
//         //         labelText: "Song Title",
//         //         filled: true,
//         //         fillColor: constants.Colors.lightGrey,
//         //         border: OutlineInputBorder(
//         //           borderSide: BorderSide.none,
//         //           borderRadius: BorderRadius.circular(20.0)
//         //         ),
//         //       ),
//         //       onTap: () {
//         //         showSearch(context: context, delegate: SongSearch());
//         //       },
//         //     ),
//         //   ),
//         // ),
//       ],
//     ),
//   );
// }

buildRemoveSong(BuildContext context) {
  return Container(
    child: Text("REMVOE"),
  );
}

class SongSearch extends SearchDelegate<String> {
  final songs = [
    "song1",
    "song2",
    "song3",
    "song4",
    "song5",
  ];

  final recentSongs = [
    "song1",
    "song2",
    "song4",
  ];

  @override
  List<Widget> buildActions(BuildContext context) => [
        IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            if (query.isEmpty) {
              close(context, '');
            } else {
              query = '';
              showSuggestions(context);
            }
          },
        )
      ];

  @override
  Widget buildLeading(BuildContext context) => IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () => close(context, ''),
      );

  @override
  Widget buildResults(BuildContext context) => Center(
        child: Column(
          children: [
            Icon(
              Icons.location_city,
              size: 120.0,
            ),
            // Query holds value of search bar text, accessible from SearchDelegate class
            Text(
              query,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 64,
                  fontWeight: FontWeight.bold),
            )
          ],
        ),
      );

  @override
  Widget buildSuggestions(BuildContext context) => FutureBuilder<List<String>>(
        future: null /**SpotifyAPI.searchSongs(query: query)**/,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Loading();
          } else {
            return Loading();
            // return buildSuggestionsSuccess(snapshot.data);
          }
        },
      );
  // {
  //   // Check if the field is empty, if it is remove suggestions, then match the inputs with the songs
  //   final suggestions = query.isEmpty ? recentSongs : songs.where((song) {
  //     final songLower = song.toLowerCase();
  //     final queryLower = query.toLowerCase();

  //     return songLower.startsWith(queryLower);
  //   }).toList();

  //   return buildSuggestionsSuccess(suggestions);
  // }

  Widget buildSuggestionsSuccess(List<String> suggestions) => ListView.builder(
        itemCount: suggestions.length,
        itemBuilder: (context, index) {
          final suggestion = suggestions[index];
          // Characters to highlight, 0 to typed characters
          final queryText = suggestion.substring(0, query.length);
          // Chacters to leave
          final remainingText = suggestion.substring(query.length);

          return ListTile(
            onTap: () {
              query = suggestion;

              close(context, suggestion);

              // showResults(context);
            },
            leading: Icon(Icons.location_city),
            // title: Text(suggestion)
            title: RichText(
              text: TextSpan(
                  text: queryText,
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0),
                  children: [
                    TextSpan(
                        text: remainingText,
                        style: TextStyle(color: Colors.grey, fontSize: 18.0)),
                  ]),
            ),
          );
        },
      );
}
