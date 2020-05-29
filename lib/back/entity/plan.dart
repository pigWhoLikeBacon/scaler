import 'package:json_annotation/json_annotation.dart';
import 'package:scaler/back/entity/base.dart';

part 'plan.g.dart';


final String tablePlan = 'plan';
final String Plan_id = 'id';
final String Plan_content = 'content';
final String Plan_isActive = 'isActive';

@JsonSerializable()
class Plan extends Base {

  int id;

  String content;

  int isActive;

  /// isActive is bool, true is 1, false is 0
  Plan(
    this.id,
    this.content,
    this.isActive,
  );

  factory Plan.fromJson(Map<String, dynamic> srcJson) =>
      _$PlanFromJson(srcJson);

  Map<String, dynamic> toJson() => _$PlanToJson(this);
}