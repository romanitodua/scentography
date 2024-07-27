import 'package:flutter/material.dart';
import 'package:scentography/utils/theme/text_theme.dart';

class SAppTheme {
  SAppTheme._();

  static ThemeData lightTheme = ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: Colors.purple,
      textTheme: STextTheme.lightTextTheme);

  static ThemeData darkTheme = ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: Colors.purple,
      textTheme: STextTheme.darkTextTheme);
}
