import 'package:dio/dio.dart';
import 'package:scaler/back/database/db.dart';
import 'package:scaler/back/entity/day.dart';
import 'package:scaler/back/entity/day_plan.dart';
import 'package:scaler/back/entity/event.dart';
import 'package:scaler/back/entity/plan.dart';
import 'package:scaler/back/service/plan_service.dart';
import 'package:scaler/web/http.dart';

class SpringUtils {
  static getDownloadJson() async {
    try {
      Response response = await HC.getDio().post("http://10.103.15.185:8081/downdata");
      print(response);
    } catch (e) {
      print(e);
    }
  }

  static Future<Map> getUploadJson() async {
    Map json = {};
    json['days'] = await _getDays();
    json['plans'] = await _getPlans();
    return json;
  }

  static Future<List> _getDays() async {
    /*
    不能直接对DB查询到的map和list进行写操作，
    否则会报Unhandled Exception: Unsupported operation: read-only。

    在json添加map前使用Map.from(),
    否则会报Unhandled Exception: Unsupported operation: read-only。
     */
    List days = [];

    List listDay = await DB.query(tableDay);
    //不使用foreach()方法遍历list，因为foreach中的异步方法不支持await
    int i = 0;
    while (i < listDay.length) {
      Day day = Day.fromJson(listDay[i]);
      Map<String, dynamic> map = Map.from(listDay[i]);
      days.add(map);

      List listEvent = await DB.find(tableEvent, Event_day_id, day.id);
      days[i]['events'] = listEvent;

      days[i]['dayPlans'] = [];
      List listDayPlan = await DB.find(tableDayPlan, DayPlan_day_id, day.id);
      int j = 0;
      while (j < listDayPlan.length) {
        DayPlan dayPlan = DayPlan.fromJson(listDayPlan[j]);
        Map<String, dynamic> map = Map.from(listDayPlan[j]);
        map.remove('day_id');
        days[i]['dayPlans'].add(map);

//        Plan plan = await PlanService.findById(dayPlan.plan_id);
//        json[i]['dayPlans'][j]['plan'] = plan.toJson();

        j++;
      }

      i++;
    }

    return days;
  }

  static Future<List> _getPlans() async {
    return await DB.query(tablePlan);
  }

  static setDownloadJson(List json) {
    try {
      json.forEach((e) {
        Map<String, dynamic> map = e;
        Day day = Day.fromJson(map);
        print(day.toJson());

        List listEvent = map['events'];
        listEvent.forEach((e) {
          Map<String, dynamic> map = e;
          Event event = Event.fromJson(map);
          print(event.toJson());
        });

        List listDayPlan = map['dayPlans'];
        listDayPlan.forEach((e) {
          Map<String, dynamic> map = e;
          Plan plan = Plan.fromJson(map['plan']);
          print(plan.toJson());

          map['day_id'] = day.id;
          map['plan_id'] = plan.id;
          DayPlan dayPlan = DayPlan.fromJson(map);
          print(dayPlan.toJson());
        });
      });
    } catch (e) {
      print('!!!Json cannot be resolved!!!');
      throw e;
    }
  }
}