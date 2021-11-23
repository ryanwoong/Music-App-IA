import 'package:flutter/material.dart';
import 'package:pep/ui/views/authenticate/authenticate.dart';

class Register extends StatefulWidget {

  // Constructor for toggleView function
  final Function ?toggleView;
  Register({ this.toggleView });
  
  

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text("REGISTER"),
    );
  }
}