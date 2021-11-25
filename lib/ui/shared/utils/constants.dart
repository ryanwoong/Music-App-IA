import 'package:flutter/material.dart';

abstract class ThemeText {
  static const titleText = TextStyle(
      color: Colors.mainColor,
      fontSize: 30,
      fontFamily: 'Montserrat',
      fontWeight: FontWeight.bold);
  static const secondaryTitleTextBlue = TextStyle(
      color: Colors.mainColor,
      fontSize: 23,
      fontFamily: 'Montserrat',
      fontWeight: FontWeight.bold);
  static const secondaryTitleTextBlack = TextStyle(
      color: Colors.black,
      fontSize: 23,
      fontFamily: 'Montserrat',
      fontWeight: FontWeight.bold);
  static const secondaryText = TextStyle(
      color: Colors.darkGrey,
      fontSize: 20,
      fontFamily: 'Montserrat',
      fontWeight: FontWeight.w500);
  static const smallText = TextStyle(
      color: Colors.darkGrey,
      fontSize: 15,
      fontFamily: 'Montserrat',
      fontWeight: FontWeight.w500);
  static const linkText = TextStyle(
      color: Colors.mainColor,
      fontSize: 15,
      fontFamily: 'Montserrat',
      fontWeight: FontWeight.w800);
  static const errorText = TextStyle(color: Color(0xFFE74C3C));
}

abstract class Colors {
  static const mainColor = Color(0xFFabc4ff);
  static const darkGrey = Color(0xFFadb5bd);
  static const lightGrey = Color(0xFFF2F3F4);
  static const black = Color(0xFF000000);
}

abstract class Button {
  // static final textButton = TextButton.styleFrom(
  //   elevation: 0,
  //   splashFactory: NoSplash.splashFactory,
  //   primary: Colors.mainColor,
  //   shape: const RoundedRectangleBorder(
  //     borderRadius: BorderRadius.all(Radius.circular(10.0)),
  //   ),
  //   fixedSize: const Size(195, 45)
  // );
  static final textButton = TextButton.styleFrom(
    splashFactory: NoSplash.splashFactory,
    backgroundColor: Colors.mainColor,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(10.0)),
    ),
  );
}
