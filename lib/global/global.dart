import 'package:scaler/back/entity/plan.dart';

DateTime global_selectedDay;
List<Plan> global_plans = [];
// _events中的key，类型为DateTime并统一为当天12点整
Map<DateTime, List> global_events;
List global_selectedEvents;