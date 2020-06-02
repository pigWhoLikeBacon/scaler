import 'package:scaler/back/entity/event.dart';
import 'package:scaler/back/entity/plan.dart';
import 'package:table_calendar/table_calendar.dart';

// ignore_for_file: public_member_api_docs, lines_longer_than_80_chars
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

DateTime global_selectedDay;
List<Plan> global_plans;
// _events中的key，类型为DateTime并统一为当天12点整
List global_selectedEvents;
//因为在其他widget中无法使calendar rebuild
// use 'CalendarPage._calendarController.setSelectedDay(CalendarPage._calendarController.selectedDay);' to rebuild calendar.
CalendarController global_calendarController;

/// Mix-in [DiagnosticableTreeMixin] to have access to [debugFillProperties] for the devtool
class Global with ChangeNotifier, DiagnosticableTreeMixin {
  Map<DateTime, List> _events = {};
  Map<DateTime, List> get events => _events;

  void setEvents(Map<DateTime, List> events) {
    _events = events;
    notifyListeners();

    _events[global_selectedDay].forEach((e) {
      Event event = e;
      print(event.toJson());
    });
  }
}