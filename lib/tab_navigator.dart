import 'package:flutter/material.dart';
import 'package:flutter_custom_dialog/flutter_custom_dialog.dart';
import 'package:flutter_screen_scaler/flutter_screen_scaler.dart';
import 'package:gzx_dropdown_menu/gzx_dropdown_menu.dart';
import 'package:scaler/back/entity/day.dart';
import 'package:scaler/back/entity/plan.dart';
import 'package:scaler/back/service/day_service.dart';
import 'package:scaler/back/service/event_service.dart';
import 'package:scaler/back/service/plan_service.dart';
import 'package:scaler/global/global.dart';
import 'package:scaler/page/calendar_page/calendar_page.dart';
import 'package:scaler/page/plan_page.dart';
import 'package:scaler/widget/add/add_widget.dart';
import 'package:provider/provider.dart';

import 'global/theme_data.dart';

GZXDropdownMenuController dropdownMenuController;

class TabNavigator extends StatefulWidget {
  @override

  _TabNavigatorState createState() => _TabNavigatorState();

  static loadData(BuildContext context) async {
    //plan_page
    var activePlans = await PlanService.getActivePlans();
    context.read<Global>().setActivePlans(activePlans);

    //calendar_page
    context.read<Global>().setSelectedDate(DayService.getDayTime(DateTime.now()));
    Day day = await DayService.setDay(context.read<Global>().selectedDate);
    context.read<Global>().setSelectedDay(day);

    List<Plan> plans = await PlanService.findListByDay(day);
    plans = PlanService.listOrderById(plans);

    Map<DateTime, List> events = {};
    List<Day> listDay = await DayService.findAll();

    //不使用foreach()方法遍历list，因为foreach中的异步方法不支持await
    int i = 0;
    while (i < listDay.length) {
      Day day = listDay[i];
      List eventsforDay = await EventService.findListByDayId(day.id);
//      eventsforDay = BaseService.listOrderById(eventsforDay);
      if (eventsforDay.length != 0) {
        events[DateTime.parse(day.date)] = eventsforDay;
      }
      i++;
    }

    context.read<Global>().setPlans(plans);
    context.read<Global>().setEvents(events);
    context.read<Global>().setSelectedEvents(
        context.read<Global>().events[context.read<Global>().selectedDate] ??
            []);
    context.read<Global>().setLog(day.log);
  }
}

class _TabNavigatorState extends State<TabNavigator> {
  int _currentIndex = 0;
  List<Widget> _pageList;

  @override
  void initState() {
    YYDialog.init(context);
    dropdownMenuController = GZXDropdownMenuController();

    TabNavigator.loadData(context);

    super.initState();

    _pageList = List();
    _pageList..add(CalendarPage())..add(PlanPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AddWidget(
        child: _pageList[_currentIndex],
        dropdownMenuController: dropdownMenuController,
      ),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(), // 底部导航栏打一个圆形的洞
        child: Row(
          children: <Widget>[
            _bottomItem(Icons.calendar_today, 'Calendar', 0),
            SizedBox(),
            _bottomItem(Icons.announcement, 'Plan', 1),
          ],
          mainAxisAlignment: MainAxisAlignment.spaceAround, //均分底部导航栏横向空间
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        heroTag: 'add',
        onPressed: () {
          if (dropdownMenuController.isShow) {
            dropdownMenuController.hide();
          } else {
            dropdownMenuController.show(0);
          }
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  //底部导航item
  IconButton _bottomItem(IconData icon, String title, int index) {
    return IconButton(
      icon: Icon(
        icon,
      ),
      onPressed: () {
        setState(() {
          _currentIndex = index;
        });
      },
      color: _currentIndex == index
          ? TD.td.accentColor
          : TD.td.unselectedWidgetColor,
    );
  }
}
