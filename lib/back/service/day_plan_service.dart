import 'package:date_format/date_format.dart';
import 'package:scaler/back/database/db.dart';
import 'package:scaler/back/entity/day.dart';
import 'package:scaler/back/entity/day_plan.dart';

class DayPlanService {
  static Future<List<DayPlan>> findListByPlanId(int planId) async {
    List<DayPlan> listDayPlan = [];
    var list = await DB.find(tableDayPlan, DayPlan_plan_id, planId);
    list.forEach((e) {
      DayPlan dayPlan = DayPlan.fromJson(e);
      listDayPlan.add(dayPlan);
    });
    return listDayPlan;
  }

  static Future<List<DayPlan>> findListByDayId(int dayId) async {
    List<DayPlan> listDayPlan = [];
    var list = await DB.find(tableDayPlan, DayPlan_day_id, dayId);
    list.forEach((e) {
      DayPlan dayPlan = DayPlan.fromJson(e);
      listDayPlan.add(dayPlan);
    });
    return listDayPlan;
  }

//  static Future<List<DayPlan>> findListByDayIdAndPlanId(int dayId, int planId) async {
//    List<DayPlan> listDayPlan = [];
//
//    Map<String, dynamic> map = {
//      DayPlan_plan_id : planId,
//      DayPlan_day_id : dayId,
//    };
//    var list = await DB.findByMap(tableDayPlan, map);
//
//    list.forEach((e) {
//      listDayPlan.add(DayPlan.fromJson(e));
//    });
//
//    return listDayPlan;
//  }

  static addRelation(int dayId, int planId) async {
    Map<String, dynamic> map = {
      DayPlan_plan_id : planId,
      DayPlan_day_id : dayId,
    };
    var list = await DB.findByMap(tableDayPlan, map);

    //plan与day无联系则执行该代码，添加联系
    if (list.length == 0) {
      DayPlan dayPlan = new DayPlan(null, dayId, planId, 0);
      DB.save(tableDayPlan, dayPlan);
    }
  }
}