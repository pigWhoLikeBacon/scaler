import 'package:json_annotation/json_annotation.dart';
import 'package:scaler/back/entity/base.dart';

part 'event.g.dart';


final String tableEvent = 'event';
final String Event_id = 'id';
final String Event_day_id = 'day_id';
final String Event_time = 'time';
final String Event_content = 'content';

@JsonSerializable()
class Event extends Base {

  int id;

  int day_id;

  String time;

  String content;

  Event(this.id,this.day_id,this.time,this.content,);

  factory Event.fromJson(Map<String, dynamic> srcJson) => _$EventFromJson(srcJson);

  Map<String, dynamic> toJson() => _$EventToJson(this);
}