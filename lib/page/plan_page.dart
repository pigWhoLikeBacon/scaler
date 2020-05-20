import 'package:flutter/material.dart';
import 'package:scaler/back/entity/plan.dart';
import 'package:scaler/widget/drawer_widget.dart';


List<Plan> _plans = [
  Plan(1, 'content1'),
  Plan(2, 'content2'),
  Plan(3, 'content3'),
  Plan(4, 'content4'),
  Plan(5, 'content5'),
  Plan(6, 'content6'),
  Plan(7, 'content7'),
  Plan(8, 'content8'),
  Plan(9, 'content9'),
];

class PlanPage extends StatefulWidget {
  @override
  _PlanPageState createState() => _PlanPageState();
}

class _PlanPageState extends State<PlanPage> with TickerProviderStateMixin {

  //缓存页面
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
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
