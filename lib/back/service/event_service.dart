import 'package:date_format/date_format.dart';
import 'package:scaler/back/database/db.dart';
import 'package:scaler/back/entity/event.dart';
import 'package:scaler/back/entity/plan.dart';
import 'package:scaler/config/config.dart';

import 'day_service.dart';

class EventService {
  static Future<List<Event>> findListByDayId(int dayId) async {
    List<Event> listEvent = [];
    List<Map<String, dynamic>> list = await DB.find(tableEvent, Event_day_id, dayId);
    list.forEach((e) {
      listEvent.add(Event.fromJson(e));
    });
    return listEvent;
  }

  static Future<List<Event>> findListByDate(DateTime date) async {
    int dayId = await DayService.setDay(date);

    return findListByDayId(dayId);
  }

  static Future<List<String>> findContentListByDayId(int dayId) async {
    List<String> listContent = [];
    List<Map<String, dynamic>> list = await DB.find(tableEvent, Event_day_id, dayId);
    list.forEach((e) {
      listContent.add(Event.fromJson(e).content);
    });
    return listContent;
  }
}