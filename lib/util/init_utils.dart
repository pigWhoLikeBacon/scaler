import 'package:date_format/date_format.dart';
import 'package:scaler/back/database/db.dart';
import 'package:scaler/back/entity/day.dart';

class InitUtils {
  static Future<int> setDay(DateTime dateTime) async {
    String date = formatDate(dateTime, [yyyy, '-', mm, '-', dd]);
    var list = await DB.find(tableDay, Day_date, date);
    Day today =  list.length == 0 ? null : Day.fromJson(list[0]);
    if (today == null) return await DB.save(tableDay, new Day(null, date, ''));
    else return today.id;
  }
}