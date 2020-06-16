import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:scaler/back/database/db.dart';
import 'package:scaler/back/entity/day.dart';
import 'package:scaler/back/entity/day_plan.dart';
import 'package:scaler/back/entity/event.dart';
import 'package:scaler/back/entity/plan.dart';
import 'package:scaler/back/service/day_plan_service.dart';
import 'package:scaler/back/service/day_service.dart';
import 'package:scaler/back/service/event_service.dart';
import 'package:scaler/global/global.dart';
import 'package:scaler/global/theme_data.dart';
import 'package:scaler/util/dialog_utils.dart';

// ignore_for_file: public_member_api_docs, lines_longer_than_80_chars
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';

class CalendarPlan extends StatefulWidget {
  final Plan plan;

  const CalendarPlan({Key key, this.plan}) : super(key: key);

  CalendarPlanState createState() => CalendarPlanState();
}

class CalendarPlanState extends State<CalendarPlan>
    with SingleTickerProviderStateMixin {
  Plan _plan;

  //为选择时添加颜色渐变动画，只能使用全局变量，使用局部变量会被销毁。
  Animation selectAnimation;
  Animation deselectAnimation;
  AnimationController controller;

  Color iconColor = TD.td.unselectedWidgetColor;
  Color activeColor;
  Color unActiveColor;

  DayPlan dayPlan;

  @override
  void initState() {
    _plan = widget.plan;

    activeColor = TD.td.accentColor;
    unActiveColor = TD.td.unselectedWidgetColor;
    iconColor = unActiveColor;

    controller =
        AnimationController(duration: Duration(milliseconds: 300), vsync: this);
    selectAnimation =
        ColorTween(begin: unActiveColor, end: activeColor).animate(controller);
    deselectAnimation =
        ColorTween(begin: activeColor, end: unActiveColor).animate(controller);

    super.initState();
  }

  _loadData() async {

    activeColor = TD.td.accentColor;
    unActiveColor = TD.td.unselectedWidgetColor;

    selectAnimation =
        ColorTween(begin: unActiveColor, end: activeColor).animate(controller);
    deselectAnimation =
        ColorTween(begin: activeColor, end: unActiveColor).animate(controller);

    dayPlan = await DayPlanService.findByDayIdPlanId(
        context.watch<Global>().selectedDay.id, _plan.id);
    if (dayPlan.isDone == 1)
      setState(() {
        iconColor = activeColor;
      });
  }

  @override
  Widget build(BuildContext context) {
    _loadData();

    return Container(
      child: ListTile(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(_plan.content),
            Icon(
              Icons.check_circle,
              color: iconColor,
            ),
          ],
        ),
        onTap: () async {
          // 设置plan为未完成状态
          if (iconColor == activeColor) {
            controller.reset();
            controller.forward();
            controller.addListener(() {
              setState(() {
                iconColor = deselectAnimation.value;
              });
            });

            dayPlan.isDone = 0;
            await DB.save(tableDayPlan, dayPlan);
          }
          // 设置plan为完成状态
          else {
            controller.reset();
            controller.forward();
            controller.addListener(() {
              if (controller.isCompleted) {
                setState(() {
                  iconColor = activeColor;
                });
              } else {
                setState(() {
                  iconColor = selectAnimation.value;
                });
              }
            });

            dayPlan.isDone = 1;
            await DB.save(tableDayPlan, dayPlan);
          }
        },
      ),
    );
  }
}
