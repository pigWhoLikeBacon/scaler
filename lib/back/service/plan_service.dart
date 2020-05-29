import 'package:scaler/back/database/db.dart';
import 'package:scaler/back/entity/plan.dart';

class PlanService {
  static Future<List<Plan>> getActivePlans() async {
    print(await DB.query(tablePlan));

    List<Plan> plans = [];
    var list = await DB.find(tablePlan, Plan_isActive, '1');

    list.forEach((e) {
      plans.add(Plan.fromJson(e));
    });
    return plans;
  }
}