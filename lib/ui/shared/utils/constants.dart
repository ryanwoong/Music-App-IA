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
}

abstract class Colors {
  static const mainColor = Color(0xFFabc4ff);
  static const darkGrey = Color(0xFFadb5bd);
  static const lightGrey = Color(0xFFF2F3F4);
  static const black = Color(0xFF000000);
}
