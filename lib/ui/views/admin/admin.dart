import 'package:flutter/material.dart';

class AdminPage extends StatelessWidget {
  const AdminPage({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        child: Center(
          child: Text(
            "ADMIN"
          ),
        ),
      ),
    );
  }
}