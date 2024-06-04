import 'package:flutter/material.dart';

class ThemeUtils{
  static ThemeData darkTheme(){
    return ThemeData(
      brightness: Brightness.dark,
      fontFamily: 'NovaMono'
    );

  }

  static ThemeData lightTheme(){
    return ThemeData(
        brightness: Brightness.light,
        fontFamily: 'NovaMono'
    );
  }
}