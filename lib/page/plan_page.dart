import 'package:flutter/material.dart';
import 'package:scaler/back/database/db.dart';
import 'package:scaler/back/entity/plan.dart';
import 'package:scaler/back/service/plan.dart';
import 'package:scaler/widget/drawer_widget.dart';


//List<Plan> _plans = [
//  Plan(1, 'content1', true,),
//  Plan(2, 'content2', true,),
//  Plan(3, 'content3', true,),
//  Plan(4, 'content4', true,),
//  Plan(5, 'content5', true,),
//  Plan(6, 'content6', true,),
//  Plan(7, 'content7', true,),
//  Plan(8, 'content8', true,),
//  Plan(9, 'content9', true,),
//];

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
        children: _plans.map((plan) => Container(
          decoration: BoxDecoration(
            border: Border.all(width: 0.8),
            borderRadius: BorderRadius.circular(12.0),
          ),
          margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          child: ExpansionTile(
//            key: new PageStorageKey<Entry>(root),
            title: new Text(plan.content),
            children: <Widget> [
              Text('data')
            ],
          )
        )).toList(),
      ),
      ),
    );
  }
}
