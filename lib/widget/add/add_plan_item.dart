import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scaler/back/database/db.dart';
import 'package:scaler/back/entity/day_plan.dart';
import 'package:scaler/back/entity/plan.dart';
import 'package:scaler/config/theme_data.dart';
import 'package:scaler/util/dialog_utils.dart';
import 'package:scaler/util/init_utils.dart';
import 'package:scaler/widget/simple_round_button.dart';

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
    DialogUtils.showLoader(context, 'Adding...');

    _formKey.currentState.save();

    int dayId = await InitUtils.setDay(DateTime.now());

    Plan plan = new Plan(null, _content, 1);
    int planId = await DB.save(tablePlan, plan);

    DayPlan dayPlan = new DayPlan(null, dayId, planId, 0);
    await DB.save(tableDayPlan, dayPlan);

    Navigator.of(context).pop();
    DialogUtils.showTextDialog(context, 'Successfully added!');

//    print(await DB.query(tablePlan));
//    print(await DB.query(tableDayPlan));
  }
}
