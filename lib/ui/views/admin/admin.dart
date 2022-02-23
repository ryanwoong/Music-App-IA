import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:pep/classes/songFile.dart';
import 'package:pep/classes/songImage.dart';
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
                    // Drop down menu
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
                            // Song name section
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
                            // Artist name section
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
                            // Select audio file section
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
                                      SongFile result = await FileService().pickAudioFile();
                                      String? _statusMessage = result.getStatusMessage();
                                      setState(() {
                                        if (_statusMessage == "File OK") {
                                          _errorColor =
                                              constants.Colors.success;
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
                            // File name
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
                            // Select image file section
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
                                      String? _statusMessage = result.getStatusMessage();
                                      setState(() {
                                        if (_statusMessage == "File OK") {
                                          _errorColor =
                                              constants.Colors.success;
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
                            // File name
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
                            // Add song button
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
                                          await DatabaseService().saveSong(
                                              _songFile,
                                              _songImage,
                                              _songNameController.text,
                                              _songArtistController.text);
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ),
                                  ],
                                )),

                            // DELETE BEFORE FINAL
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

                                          DatabaseService().getUsername("U20Iqj8BLXdiTVhe2DFEoutJM8j2");
                                          // FirebaseFirestore.instance
                                          //     .collection("artists")
                                          //     .doc("justin")
                                          //     .collection("songs")
                                          //     .doc("Tester")
                                          //     .get()
                                          //     .then((val) {
                                          //   print(val["artists"]);
                                          // });
                                          // DatabaseService().getLikes("Justin", "Tester");
                                          // Future<List<Reference>?> items = DatabaseService().getSongImg("Jeremy", "Summer");
                                          // DatabaseService().getRanArtist();
                                          // DatabaseService().getAllSongs();
                                        },
                                      ),
                                    ),
                                  ],
                                )),
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

