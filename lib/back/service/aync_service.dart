import 'package:date_format/date_format.dart';
import 'package:scaler/back/database/db.dart';
import 'package:scaler/back/entity/day.dart';
import 'package:scaler/back/entity/day_plan.dart';
import 'package:scaler/back/entity/event.dart';
import 'package:scaler/back/entity/plan.dart';
import 'package:scaler/web/http.dart';

import 'day_plan_service.dart';
import 'day_service.dart';

class AyncService {
  static saveServiceData() {

  }

  static Future<Map<String, dynamic>> getLocalData() async {
    return {
      tableDay : await _getDays(),
      tableDayPlan : await _getDayPlans(),
      tableEvent : await _getEvents(),
      tablePlan : await _getPlans(),
    };
  }

  static Future<List> _getDays() async {
    return await DB.query(tableDay);
  }

  static Future<List> _getDayPlans() async {
    return await DB.query(tableDayPlan);
  }

  static Future<List> _getEvents() async {
    return await DB.query(tableEvent);
  }

  static Future<List> _getPlans() async {
    return await DB.query(tablePlan);
  }
}