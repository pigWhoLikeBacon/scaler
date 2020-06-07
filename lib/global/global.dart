import 'package:scaler/back/entity/day.dart';
import 'package:scaler/back/entity/plan.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Mix-in [DiagnosticableTreeMixin] to have access to [debugFillProperties] for the devtool
class Global with ChangeNotifier, DiagnosticableTreeMixin {
  // 保存了所有的day中的events。
  // _events中的key，类型为DateTime并统一为当天12点整。
  Map<DateTime, List> _events = {};

  // 保存了当前day的日期。
  DateTime _selectedDate = DateTime.now();

  // 保存了当前day的日期。
  Day _selectedDay = null;

  // 保存了当前day的palns。
  List<Plan> _plans = [];

  // 保存了当前选择day的events。
  List _selectedEvents = [];

  // 保存了当前未失效的plans。
  List<Plan> _activePlans = [];

  // 保存了当前day的log。
  String _log = '';

  // Get and set
  Map<DateTime, List> get events => _events;

  DateTime get selectedDate => _selectedDate;

  Day get selectedDay => _selectedDay;

  List<Plan> get plans => _plans;

  List get selectedEvents => _selectedEvents;

  List<Plan> get activePlans => _activePlans;

  String get log => _log;

  void setEvents(Map<DateTime, List> events) {
    _events = events;
    notifyListeners();
  }

  void setSelectedDate(DateTime selectedDate) {
    _selectedDate = selectedDate;
//    notifyListeners();
  }

  void setSelectedDay(Day selectedDay) {
    _selectedDay = selectedDay;
//    notifyListeners();
  }

  void setPlans(List<Plan> plans) {
    _plans = plans;
    notifyListeners();
  }

  void setSelectedEvents(List selectedEvents) {
    _selectedEvents = selectedEvents;
    notifyListeners();
  }

  void setActivePlans(List<Plan> activePlans) {
    _activePlans = activePlans;
    notifyListeners();
  }

  void setLog(String log) {
    _log = log;
    notifyListeners();
  }
  // Get and set
}