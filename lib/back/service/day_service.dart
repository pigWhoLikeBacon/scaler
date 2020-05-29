import 'package:date_format/date_format.dart';
import 'package:scaler/back/database/db.dart';
import 'package:scaler/back/entity/day.dart';

class DayService {
  static Future<int> setDay(DateTime dateTime) async {
    String date = formatDate(dateTime, [yyyy, '-', mm, '-', dd]);
    var list = await DB.find(tableDay, Day_date, date);
    Day today =  list.length == 0 ? null : Day.fromJson(list[0]);
    if (today == null) return await DB.save(tableDay, new Day(null, date, ''));
    else return today.id;
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

  static Future<void> eachDays(DateTime start, DateTime end, Function function) async {
    while (_isEarlyDay(start, end)) {
      int dayId = await setDay(start);
      function(dayId);
      start = start.add(Duration(days: 1));
    }
  }

  static _isEarlyDay(DateTime start, DateTime end) {
    if (start.year > end.year) return false;
    if (start.month > end.month) return false;
    if (start.day > end.day) return false;
    return true;
  }
}