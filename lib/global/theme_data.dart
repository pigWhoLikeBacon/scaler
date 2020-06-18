import 'package:flutter/material.dart';

import 'config.dart';

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

final Map<String, Color> contentColors = {
  'light' : Colors.blue[100],
  'dark' : Colors.white12,
};

final Map<String, Color> logFrameColors = {
  'light' : Colors.cyan,
  'dark' : Colors.deepOrange[400],
};

final Map<String, Color> logBackgroundColors = {
  'light' : Colors.white,
  'dark' : Color(0xff424242),
};

final Map<String, Color> buttonTextColors = {
  'light' : Colors.white,
  'dark' : Colors.white,
};

final Map<String, Color> selectedColors = {
  'light' : Colors.blue,
  'dark' : Colors.deepOrange[400],
};

final Map<String, Color> todayColors = {
  'light' : Colors.blue[200],
  'dark' : Colors.deepOrange[200],
};

final Map<String, Color> markersColors = {
  'light' : Colors.black54,
  'dark' : Colors.white70,
};

abstract class TD {
  static ThemeData td;

  static Color contentColor;
  static Color logFrameColor;
  static Color buttonTextColor;
  static Color selectedColor;
  static Color todayColor;
  static Color markersColor;
  static Color logBackgroundColor;

  static init() {
    td = themes[Config.get(config_themeKey)];
    contentColor = contentColors[Config.get(config_themeKey)];
    logFrameColor = logFrameColors[Config.get(config_themeKey)];
    buttonTextColor = buttonTextColors[Config.get(config_themeKey)];
    selectedColor = selectedColors[Config.get(config_themeKey)];
    todayColor = todayColors[Config.get(config_themeKey)];
    markersColor = markersColors[Config.get(config_themeKey)];
    logBackgroundColor = logBackgroundColors[Config.get(config_themeKey)];
  }
}