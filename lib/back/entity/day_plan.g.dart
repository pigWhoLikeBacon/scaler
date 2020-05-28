// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'day_plan.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DayPlan _$DayPlanFromJson(Map<String, dynamic> json) {
  return DayPlan(
    json['id'] as int,
    json['day_id'] as int,
    json['plan_id'] as int,
    json['isDone'] as int,
  );
}

Map<String, dynamic> _$DayPlanToJson(DayPlan instance) => <String, dynamic>{
      'id': instance.id,
      'day_id': instance.day_id,
      'plan_id': instance.plan_id,
      'isDone': instance.isDone,
    };
