import 'package:scaler/back/database/db.dart';
import 'package:scaler/back/entity/day.dart';
import 'package:scaler/back/entity/event.dart';

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
    Day day = await DayService.setDay(date);
    return findListByDayId(day.id);
  }

  static Future<int> deleteById(int id) async {
    return await DB.deleteById(tableEvent, id);
  }
}