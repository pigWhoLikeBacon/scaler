import 'package:flutter/material.dart';
import 'package:scaler/back/database/db.dart';
import 'package:scaler/back/entity/day.dart';
import 'package:scaler/back/entity/day_plan.dart';
import 'package:scaler/back/entity/plan.dart';
import 'package:scaler/back/service/day_plan_service.dart';
import 'package:scaler/back/service/day_service.dart';
import 'package:scaler/back/service/plan_service.dart';
import 'package:scaler/global/global.dart';
import 'package:scaler/util/dialog_utils.dart';
import 'package:scaler/util/toast_utils.dart';
import 'package:scaler/widget/drawer_widget.dart';
import 'package:sqflite/sqflite.dart';
import 'package:provider/provider.dart';


class PlanPage extends StatefulWidget {
  @override
  _PlanPageState createState() => _PlanPageState();
}

class _PlanPageState extends State<PlanPage>{

  @override
  void initState() {
    _loadData();

    super.initState();
  }

  _loadData() async {
    var plans = await PlanService.getActivePlans();
    setState(() {
      context.read<Global>().setActivePlans(plans);
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
        children: context.watch<Global>().activePlans.map((plan) => _getPlanWidget(plan)).toList(),
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
          initiallyExpanded: false,
          children: <Widget> [
            Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ListTile(
                    title: TextFormField(
                      maxLines: 3,
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
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                FlatButton(
                    textColor: Colors.red,
                    child: Text('Delete'),
                    onPressed: () {
                      DialogUtils.editYYBottomSheetDialog(
                          'Delete this item permanently', () {
                        _delete(plan);
                      });
                    }),
                FlatButton(
                    child: Text('Edit'),
                    onPressed: () {
                      _formKey.currentState.save();
                      DialogUtils.editYYBottomSheetDialog(
                          'Edit this item permanently', () {
                        _edit(plan, _content);
                      });
                    })
              ],
            ),
          ],
        )
    );
  }

  _delete(Plan plan) async {
    print('delete');
    plan.isActive = 0;
    await DB.save(tablePlan, plan);

    ToastUtils.show('delete successful! ID: ' + plan.id.toString());

    setState(() {
      List<Plan> activePlans = context.read<Global>().activePlans;

      activePlans.removeWhere((e) {
        Plan t = e;
        return e.id == plan.id;
      });

      context.read<Global>().setActivePlans(activePlans);
    });
  }

  _edit(Plan plan, String content) async {
    //设置plan失效
    plan.isActive = 0;
    await DB.save(tablePlan, plan);

    //重新创建一个plan
    plan.isActive = 1;
    plan.id = null;
    plan.content = content;
    plan.id = await DB.save(tablePlan, plan);

    setState(() {
      List<Plan> activePlans = context.read<Global>().activePlans;

      activePlans.removeWhere((e) {
        Plan t = e;
        return e.id == plan.id;
      });

      activePlans.add(plan);

      context.read<Global>().setActivePlans(activePlans);
    });

    ToastUtils.show('Edit successful! ID: ' + plan.id.toString());

    plan.content = content;
  }
}
