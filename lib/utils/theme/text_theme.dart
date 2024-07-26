import 'package:flutter/material.dart';

class STextTheme {
  STextTheme._();

  static TextTheme lightTextTheme = TextTheme(
      headlineLarge: TextStyle().copyWith(
          fontSize: 32.0, fontWeight: FontWeight.bold, color: Colors.black));
  static TextTheme darkTextTheme = TextTheme(
      headlineLarge: TextStyle().copyWith(
          fontSize: 32.0, fontWeight: FontWeight.bold, color: Colors.white));
}
