import 'package:date_format/date_format.dart';
import 'package:scaler/back/database/db.dart';
import 'package:scaler/back/entity/day.dart';
import 'package:scaler/back/entity/day_plan.dart';
import 'package:scaler/back/entity/plan.dart';

import 'day_plan_service.dart';
import 'day_service.dart';

class PlanService {
  static Future<Plan> findById(int id) async {
    var list = await DB.find(tablePlan, Plan_id, id);
    Plan plan = list.length == 0 ? null : Plan.fromJson(list[0]);
    return plan;
  }

  static Future<List<Plan>> getActivePlans() async {
    print(await DB.query(tablePlan));

    List<Plan> plans = [];
    var list = await DB.find(tablePlan, Plan_isActive, '1');

    list.forEach((e) {
      plans.add(Plan.fromJson(e));
    });
    return plans;
  }

  ///Get the creation day of the plan.
  static Future<Day> getStartDay(Plan plan) async {
    var listDayPlan = await DayPlanService.findListByPlanId(plan.id);
    DayPlan first = listDayPlan[0];

    return await DayService.findById(first.day_id);
  }

  ///在today以及today之后，day与plan并未建立联系，为特殊情况，直接返回所有未失效的plan。
  static Future<List<Plan>> findListByDay(Day day) async {
    bool cond1 = formatDate(DateTime.now(), [yyyy, '-', mm, '-', dd]) == day.date;
    bool cond2 = DateTime.parse(day.date).isAfter(DateTime.now());
    if (cond1 || cond2)
      return getActivePlans();
    else {
      List<Plan> listPlan = [];
      List<DayPlan> listDayPlan = await DayPlanService.findListByDayId(day.id);

      //不使用foreach()方法遍历list，因为foreach中的异步方法不支持await
      int i = 0;
      while (i < listDayPlan.length) {
        DayPlan dayPlan = listDayPlan[i];
        Plan plan = await findById(dayPlan.plan_id);
        listPlan.add(plan);
        i++;
      }

      return listPlan;
    }
  }
}