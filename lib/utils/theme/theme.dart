import 'package:flutter/material.dart';
import 'package:scentography/utils/theme/text_theme.dart';

class SAppTheme {
  SAppTheme._();

  static ThemeData lightTheme = ThemeData(
      useMaterial3: true,
      fontFamily: 'Poppins',
      brightness: Brightness.light,
      primaryColor: Colors.purple,
      scaffoldBackgroundColor: Colors.white,
      textTheme: STextTheme.lightTextTheme);

  static ThemeData darkTheme = ThemeData(
      useMaterial3: true,
      fontFamily: 'Poppins',
      brightness: Brightness.dark,
      primaryColor: Colors.purple,
      scaffoldBackgroundColor: Colors.white,
      textTheme: STextTheme.darkTextTheme);
}
