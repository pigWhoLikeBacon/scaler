import 'package:dio/dio.dart';
import 'package:scaler/back/database/db.dart';
import 'package:scaler/back/entity/day.dart';
import 'package:scaler/back/entity/day_plan.dart';
import 'package:scaler/back/entity/event.dart';
import 'package:scaler/back/entity/plan.dart';
import 'package:scaler/web/http.dart';

class AyncUtils {
  static Future<Map> getLocalData() async {
    return {
      "days" : await _getDays(),
      "dayPlans" : await _getDayPlans(),
      "events" : await _getEvents(),
      "plans" : await _getPlans(),
    };
  }

  static getServiceData() async {
    Response response = await HC.getDio().get('http://192.168.123.79:8081/downdata');
    print(response);
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