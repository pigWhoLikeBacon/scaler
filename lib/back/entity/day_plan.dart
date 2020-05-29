import 'package:json_annotation/json_annotation.dart';
import 'package:scaler/back/entity/base.dart';

part 'day_plan.g.dart';


final String tableDayPlan = 'day_plan';
final String DayPlan_id = 'id';
final String DayPlan_day_id = 'day_id';
final String DayPlan_plan_id = 'plan_id';
final String DayPlan_isDone = 'isDone';

@JsonSerializable()
class DayPlan extends Base {

  int id;

  int day_id;

  int plan_id;

  int isDone;

  /// isDone is bool, true is 1, false is 0
  DayPlan(this.id,this.day_id,this.plan_id,this.isDone,);

  factory DayPlan.fromJson(Map<String, dynamic> srcJson) => _$DayPlanFromJson(srcJson);

  Map<String, dynamic> toJson() => _$DayPlanToJson(this);

}