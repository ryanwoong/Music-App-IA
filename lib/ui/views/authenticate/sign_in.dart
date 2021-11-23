import 'package:flutter/material.dart';
import 'package:pep/ui/views/authenticate/authenticate.dart';
import '../../shared/utils/constants.dart' as constants;

class SignIn extends StatefulWidget {
  // Constructor for toggleView function
  final Function? toggleView;
  SignIn({this.toggleView});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  // Private variable
  final _formKey = GlobalKey<FormState>();
  String error = '';
  bool loading = false;

  // Text field intial states
  String email = '';
  String password = '';


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          padding: const EdgeInsets.symmetric(vertical: 125),
          child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "pep",
              style: constants.ThemeText.titleText
            ),
            SizedBox(height: 50.0),
            Expanded(
              child: Form(
              key: _formKey,
              child: ListView(
                padding: EdgeInsets.only(top: 50.0, left: 50.0, right: 50.0),
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: "Classroom Name",
                        hintText: "What's name of the new classroom?",
                        fillColor: constants.Colors.lightGrey,
                        filled: true
                      ),
                    )
                  ),
                  SizedBox(height: 8.0,),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Description",
                        hintText: "Description of the new classroom",
                      ),
                      //maxLines: 5,
                    ),
                  ),
                ]
              ),
            ),
          ),
        ],
      ),
        ),
      ),
    );
  }
}
