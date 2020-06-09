import 'package:scaler/back/database/db.dart';
import 'package:scaler/back/entity/day.dart';
import 'package:scaler/back/entity/day_plan.dart';
import 'package:scaler/back/entity/event.dart';
import 'package:scaler/back/entity/plan.dart';
import 'package:scaler/back/service/plan_service.dart';

class SpringUtils {
  static Future<List> getUploadJson() async {
    /*
    不能直接对DB查询到的map和list进行写操作，
    否则会报Unhandled Exception: Unsupported operation: read-only。

    在json添加map前使用Map.from(),
    否则会报Unhandled Exception: Unsupported operation: read-only。
     */
    List json = [];

    List listDay = await DB.query(tableDay);
    //不使用foreach()方法遍历list，因为foreach中的异步方法不支持await
    int i = 0;
    while (i < listDay.length) {
      Day day = Day.fromJson(listDay[i]);
      Map<String, dynamic> map = Map.from(listDay[i]);
      json.add(map);

      List listEvent = await DB.find(tableEvent, Event_day_id, day.id);
      json[i]['events'] = listEvent;

      json[i]['dayPlans'] = [];
      List listDayPlan = await DB.find(tableDayPlan, DayPlan_day_id, day.id);
      int j = 0;
      while (j < listDayPlan.length) {
        DayPlan dayPlan = DayPlan.fromJson(listDayPlan[j]);
        Map<String, dynamic> map = Map.from(listDayPlan[j]);
        map.remove('day_id');
        map.remove('plan_id');
        json[i]['dayPlans'].add(map);

        Plan plan = await PlanService.findById(dayPlan.plan_id);
        json[i]['dayPlans'][j]['plan'] = plan.toJson();

        j++;
      }

      i++;
    }

    return json;
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
          print(event);
        });

        List listDayPlan = map['dayPlans'];
        listDayPlan.forEach((e) {
          Map<String, dynamic> map = e;
          DayPlan dayPlan = DayPlan.fromJson(map);
          print(dayPlan);

          List listPlan = map['plan'];
        });
      });
    } catch (e) {
      print('!!!Json cannot be resolved!!!');
      throw e;
    }
  }
}