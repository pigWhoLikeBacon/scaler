import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scaler/back/database/db.dart';
import 'package:scaler/back/entity/day.dart';
import 'package:scaler/back/entity/day_plan.dart';
import 'package:scaler/back/entity/plan.dart';
import 'package:scaler/back/service/day_service.dart';
import 'package:scaler/global/global.dart';
import 'package:scaler/global/theme_data.dart';
import 'package:scaler/navigator/tab_navigator.dart';
import 'package:scaler/util/dialog_utils.dart';
import 'package:scaler/widget/simple_round_button.dart';
import 'package:provider/provider.dart';

class AddPlanItem extends StatefulWidget {
  AddPlanItem();

  AddPlanItemState createState() => AddPlanItemState();
}

class AddPlanItemState extends State<AddPlanItem> {
  String _content;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Container(
              alignment: Alignment.center,
              child: ListView(
                children: <Widget>[
                  Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        ListTile(
                          title: TextFormField(
//                        initialValue: Config.get('username'),
                            maxLines: 6,
                            minLines: 1,
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
                  )
                ],
              ),
//                color: Colors.cyanAccent,
            ),
          ),
          Expanded(
            child: Container(
              alignment: Alignment.center,
              child: SimpleRoundButton(
                backgroundColor: TD.td.accentColor,
                textColor: Colors.white,
                buttonText: Text("SUBMIT"),
                onPressed: () {
                  _submit();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  _submit() async {
    FocusScope.of(context).requestFocus(FocusNode());
    DialogUtils.showLoader(context, 'Adding...');

    String info = '';
    _formKey.currentState.save();

    Day day = await DayService.setDay(DateTime.now());
    Plan plan = new Plan(null, _content, 1);

    try {
      plan.id = await DB.save(tablePlan, plan);
      DayPlan dayPlan = new DayPlan(null, day.id, plan.id, 0);
      dayPlan.id = await DB.save(tableDayPlan, dayPlan);
      info = 'Successfully added!';
    } catch (e) {
      info = 'Error' + e.toString();
      throw e;
    }

    setState(() {
      List<Plan> activePlans = context.read<Global>().activePlans;

      activePlans.add(plan);

      context.read<Global>().setActivePlans(activePlans);
    });

    Navigator.of(context).pop();
    DialogUtils.showTextDialog(context, info);
    dropdownMenuController.hide();
//    print(await DB.query(tablePlan));
//    print(await DB.query(tableDayPlan));
  }
}
