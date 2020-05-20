import 'package:json_annotation/json_annotation.dart';
import 'package:scaler/back/entity/base.dart';

part 'day.g.dart';


final String tableDay = 'day';
final String Day_id = 'id';
final String Day_date = 'date';
final String Day_log = 'log';

@JsonSerializable()
class Day extends Base {

  int id;

  String date;

  String log;

  Day(this.id,this.date,this.log,);

  factory Day.fromJson(Map<String, dynamic> srcJson) => _$DayFromJson(srcJson);

  Map<String, dynamic> toJson() => _$DayToJson(this);
}
