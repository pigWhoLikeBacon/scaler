import 'package:scaler/back/entity/plan.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Mix-in [DiagnosticableTreeMixin] to have access to [debugFillProperties] for the devtool
class Global with ChangeNotifier, DiagnosticableTreeMixin {
  // 保存了所有的day中的events。
  // _events中的key，类型为DateTime并统一为当天12点整。
  Map<DateTime, List> _events = {};

  // 保存了当前选择的日期。
  DateTime _selectedDay = DateTime.now();

  // 保存了当前选择day的palns。
  List<Plan> _plans = [];

  // 保存了当前选择day的events。
  List _selectedEvents = [];

  // Get and set
  Map<DateTime, List> get events => _events;

  DateTime get selectedDay => _selectedDay;

  List<Plan> get plans => _plans;

  List get selectedEvents => _selectedEvents;

  void setEvents(Map<DateTime, List> events) {
    _events = events;
    notifyListeners();
  }

  void setSelectedDay(DateTime selectedDay) {
    _selectedDay = selectedDay;
//    notifyListeners();
  }

  void setPlans(List<Plan> plans) {
    _plans = plans;
//    notifyListeners();
  }

  void setSelectedEvents(List selectedEvents) {
    _selectedEvents = selectedEvents;
//    notifyListeners();
  }
  // Get and set
}