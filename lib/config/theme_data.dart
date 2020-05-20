import 'package:flutter/material.dart';

final Map<String, ThemeData> themes = {
  'light' : ThemeData(
    primaryColor: Colors.blue,
    buttonColor: Colors.blue,
    brightness: Brightness.light,
  ),
  'dark' : ThemeData(
    accentColor: Colors.deepOrange[400],
    buttonColor: Colors.deepOrange[400],
    brightness: Brightness.dark,
  )
};