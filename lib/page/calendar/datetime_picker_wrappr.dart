import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:scaler/back/database/db.dart';
import 'package:scaler/back/entity/day.dart';
import 'package:scaler/back/entity/event.dart';
import 'package:scaler/back/service/day_service.dart';
import 'package:scaler/config/theme_data.dart';
import 'package:scaler/util/dialog_utils.dart';
import 'package:scaler/widget/simple_round_button.dart';

class DateTimePickerWrappr extends StatefulWidget {

  DateTimePickerWrappr();

  DateTimePickerWrapprState createState() => DateTimePickerWrapprState();
}

class DateTimePickerWrapprState extends State<DateTimePickerWrappr> {
  DateTime _dateTime;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
  }
}
