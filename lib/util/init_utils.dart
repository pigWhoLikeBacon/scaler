import 'package:date_format/date_format.dart';
import 'package:scaler/back/database/db.dart';
import 'package:scaler/back/entity/day.dart';

class InitUtils {
  static setToday() async {
    DateTime currentTime = DateTime.now();
    print(currentTime);
    String date = formatDate(currentTime, [yyyy, '-', mm, '-', dd]);
    print(date);
    var list = await DB.find(tableDay, Day_date, date);
    Day today =  list.length == 0 ? null : Day.fromJson(list[0]);
    print(today);
    if (today == null) {
      DB.save(tableDay, new Day(null, date, ''));
    }
  }
}