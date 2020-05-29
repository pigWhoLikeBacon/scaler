import 'package:date_format/date_format.dart';
import 'package:scaler/back/database/db.dart';
import 'package:scaler/back/entity/day.dart';
import 'package:scaler/back/entity/day_plan.dart';

class DayPlanService {
  static Future<List<DayPlan>> findListByPlanId(int PlanId) async {
    List<DayPlan> list_dayPlan = [];
    var list = await DB.find(tableDayPlan, DayPlan_plan_id, PlanId);
    list.forEach((e) {
      DayPlan dayPlan = DayPlan.fromJson(e);
      list_dayPlan.add(dayPlan);
    });
    return list_dayPlan;
  }
}