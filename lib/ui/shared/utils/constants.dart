import 'package:flutter/material.dart';

abstract class ThemeText {
  static const titleText = TextStyle(
      color: Colors.mainColor, fontSize: 30, fontFamily: 'Montserrat', fontWeight: FontWeight.bold);
  static const secondaryTitleText = TextStyle(
      color: Colors.mainColor, fontSize: 23, fontFamily: 'Montserrat', fontWeight: FontWeight.bold);
  static const secondaryText = TextStyle(
      color: Colors.darkGrey, fontSize: 20, fontFamily: 'Montserrat', fontWeight: FontWeight.w500);
}

abstract class Colors {
  static const mainColor = Color(0xFFabc4ff);
  static const darkGrey = Color(0xFFadb5bd);
}
