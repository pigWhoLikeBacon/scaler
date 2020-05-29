import 'package:flutter/material.dart';
import 'package:scaler/back/database/db.dart';
import 'package:scaler/back/entity/day.dart';
import 'package:scaler/back/entity/day_plan.dart';
import 'package:scaler/back/entity/plan.dart';
import 'package:scaler/back/service/day_plan_service.dart';
import 'package:scaler/back/service/day_service.dart';
import 'package:scaler/back/service/plan_service.dart';
import 'package:scaler/util/dialog_utils.dart';
import 'package:scaler/widget/drawer_widget.dart';
import 'package:sqflite/sqflite.dart';


class PlanPage extends StatefulWidget {
  @override
  _PlanPageState createState() => _PlanPageState();
}

class _PlanPageState extends State<PlanPage>{

  List<Plan> _plans = [];

  @override
  void initState() {
    _loadData();

    super.initState();
  }

  _loadData() async {
    var plans = await PlanService.getActivePlans();
    setState(() {
      _plans = plans;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plans'),
      ),
      drawer: DrawerWidget(),
      body: Center(
      child: new ListView(
        children: _plans.map((plan) => _getPlanWidget(plan)).toList(),
      ),
      ),
    );
  }

  Widget _getPlanWidget(Plan plan) {
    String _content;
    final _formKey = GlobalKey<FormState>();

    return Container(
        decoration: BoxDecoration(
          border: Border.all(width: 0.8),
          borderRadius: BorderRadius.circular(12.0),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        child: ExpansionTile(
//            key: new PageStorageKey<Entry>(root),
          title: new Text(plan.content),
          children: <Widget> [
            Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ListTile(
                    title: TextFormField(
//                        initialValue: Config.get('username'),
                      maxLines: 6,
                      minLines: 3,
                      decoration: InputDecoration(labelText: 'Content'),
                      validator: (val) =>
                      val.length < 1 ? 'Content Required' : null,
                      onSaved: (val) => _content = val,
                      obscureText: false,
                      keyboardType: TextInputType.text,
                      autocorrect: false,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              alignment: Alignment.bottomRight,
              child: FlatButton(
                child: Text('Edit'),
                onPressed: () async {
                  print(plan.id);
                  DialogUtils.showLoader(context, 'Editing...');

                  /*
                  找到该计划的创建时间。
                  遍历创建时间到现在之间的每一天，如果没有联系则建立联系。
                  设置该计划为失效。
                   */
                  try {
                    print(await DB.query(tablePlan));
                    print(await DB.query(tableDayPlan));
                    print(await DB.query(tableDay));

                    _formKey.currentState.save();

                    var list_dayPlan = await DayPlanService.findListByPlanId(plan.id);
                    DayPlan start = list_dayPlan[0];

                    Day startDay = await DayService.findById(start.day_id);

                    print(startDay.date);

                    DayService.eachDays(DateTime.parse(startDay.date), DateTime.now(), (dayId) async {
                      print(dayId);
                      Map<String, dynamic> map = {
                        DayPlan_plan_id : plan.id,
                        DayPlan_day_id : dayId,
                      };
                      var list = await DB.findByMap(tableDayPlan, map);
                      print(list);

                      //计划与该日期无联系则执行该代码，添加联系
                      if (list.length == 0) {
                        DayPlan dayPlan = new DayPlan(null, dayId, plan.id, 0);
                        DB.save(tableDayPlan, dayPlan);
                      }
//                      var list = DB.find(tableDayPlan, DayPlan_day_id, dayId);
//                      DayPlan dayPlan = new DayPlan(null, dayId, plan.id, isDone)
                    });

                    print('!!!');

                    Navigator.of(context).pop();
                    DialogUtils.showTextDialog(context, 'Successfully edited!');
                  } catch (e) {
                    Navigator.of(context).pop();
                    DialogUtils.showTextDialog(context, 'Error' + e.toString());
                    throw e;
                  }
                  print(_content);
                },
              ),
            ),
          ],
        )
    );
  }
}
