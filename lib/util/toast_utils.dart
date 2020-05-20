import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:scaler/config/config.dart';
import 'package:scaler/config/theme_data.dart';

class ToastUtils {
  static show(String text) {
    Fluttertoast.showToast(
        msg: text,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor:
        themes[Config.get('themeKey')].dialogBackgroundColor,
        fontSize: 16.0);
  }
}