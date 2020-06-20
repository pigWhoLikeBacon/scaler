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
//    print(await DB.query(tablePlan));

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

//    print(plan.toJson());
//    print(await DB.query(tablePlan));
//    print(await DB.query(tableDayPlan));
//    print(listDayPlan);

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

  static List<Plan> listOrderById(List<Plan> list) {
    if (list.length < 2) {
      //如果只有一个值不需要排序
      return list;
    } else {
      //获取比较的标准（参考）值
      Plan pivot = list[0];
      //创建一个集合用来存储小于等于标准值的数值
      // 没有元素，需要显式指定泛型参数为 int 否则报错 List<dynamic>' is not a subtype of type 'List<int>
      List<Plan> less = [];
      //创建一个集合用来存储比标准值大的数值
      List<Plan> greater = [];
      //将标准值从集合中移除
      list.removeAt(0);
      //遍历整个集合
      for (var plan in list) {
        if (plan.id <= pivot.id) {
          //如果小于等于标准值放入less集合中
          less.add(plan);
        } else {
          //如果大于标准值放入greater集合中
          greater.add(plan);
        }
      }
      //使用递归的方式，对less 和 greater 再进行排序，最终返回排序好的集合
      return listOrderById(less) + [pivot] + listOrderById(greater);
    }
  }
}