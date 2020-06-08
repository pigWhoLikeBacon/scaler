import 'package:scaler/back/database/db.dart';
import 'package:scaler/back/entity/day.dart';
import 'package:scaler/back/entity/day_plan.dart';
import 'package:scaler/back/entity/event.dart';
import 'package:scaler/back/entity/plan.dart';

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

      json.add(Map.from(listDay[i]));

      List listEvent = await DB.find(tableEvent, Event_day_id, day.id);
      json[i]['events'] = listEvent;

      List listDayPlan = await DB.find(tableDayPlan, DayPlan_day_id, day.id);
      json[i]['dayPlans'] = listDayPlan;

      int j = 0;
      while (j < listDayPlan.length) {
        DayPlan dayPlan = DayPlan.fromJson(listDayPlan[j]);

        List listPlan = await DB.find(tablePlan, Plan_id, dayPlan.plan_id);
//        json

        j++;
      }

      i++;
    }

    return json;
  }
}