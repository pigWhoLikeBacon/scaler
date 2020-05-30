import 'package:date_format/date_format.dart';
import 'package:scaler/back/database/db.dart';
import 'package:scaler/back/entity/day.dart';
import 'package:scaler/back/entity/day_plan.dart';
import 'package:scaler/back/entity/plan.dart';
import 'package:scaler/back/service/day_plan_service.dart';
import 'package:scaler/back/service/plan_service.dart';

class DayService {
  ///plan失效时会调用方法添加所有的联系，不必再去管失效的plan。
  ///从有效的plan入手，将和plan存在关系的day建立，并添加联系。
  ///此处算法可优化，闲的时候可以来康康。
  static initDays() async {
    List<Plan> activePlans = await PlanService.getActivePlans();

    //不使用foreach()方法遍历list，因为foreach中的异步方法不支持await
    int i = 0;
    while (i < activePlans.length) {
      Plan plan = activePlans[i];
      Day startDay = await PlanService.getStartDay(plan);
      DateTime start = DateTime.parse(startDay.date);
      DateTime end = DateTime.now();
      //调用此方法时已经初始化需要遍历遍历的day。
      eachDays(start, end, (day) {
        DayPlanService.addRelation(day.id, plan.id);
      });
      i++;
    }

    await setDay(DateTime.now());

    print('initDays()');
  }

  static Future<Day> setDay(DateTime dateTime) async {
    String date = formatDate(dateTime, [yyyy, '-', mm, '-', dd]);
    var list = await DB.find(tableDay, Day_date, date);
    Day day =  list.length == 0 ? null : Day.fromJson(list[0]);
    if (day == null) {
      day = new Day(null, date, '');
      day.id = await DB.save(tableDay, day);
    }
    return day;
  }

  static Future<Day> findById(int id) async {
    var list = await DB.find(tableDay, Day_id, id);
    Day day = list.length == 0 ? null : Day.fromJson(list[0]);
    return day;
  }

  static Future<List<Day>> findAll() async {
    List<Day> listDay = [];
    List<Map<String, dynamic>> list = await DB.query(tableDay);
    list.forEach((e) {
      listDay.add(Day.fromJson(e));
    });
    return listDay;
  }

  ///调用此方法时，遍历[start,end)之间所有的day。
  ///若该day不存在，此方法会自动创建。
  static Future<void> eachDays(DateTime start, DateTime end, Function(Day day) function) async {
    while (isEarlyDay(start, end)) {
      Day day = await setDay(start);
      function(day);
      start = start.add(Duration(days: 1));
    }
  }

  static isEarlyDay(DateTime start, DateTime end) {
    if (start.year > end.year) return false;
    if (start.month > end.month) return false;
    if (start.day > end.day) return false;
    return true;
  }
}