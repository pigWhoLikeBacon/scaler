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
  static saveServiceData(Map<String, dynamic> map) async {
    await DB.initDeleteDb();

    map.forEach((key, value) async {
//      print('key.toString()');
//      print(key.toString());
//      print('value.toString()');
//      print(value.toString());

      String tableName = key;
      List list = value;

      //不使用foreach()方法遍历list，因为foreach中的异步方法不支持await
      int i = 0;
      while (i < list.length) {
        Map<String, dynamic> map2 = list[i];
        await DB.insert(tableName, map2);
        i++;
      }
    });
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