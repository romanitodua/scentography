import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class STextTheme {
  STextTheme._();

  static TextTheme lightTextTheme = GoogleFonts.robotoTextTheme(
    ThemeData.light().textTheme,
  );

  static TextTheme darkTextTheme = GoogleFonts.robotoTextTheme(
    ThemeData.dark().textTheme,
  );
}
