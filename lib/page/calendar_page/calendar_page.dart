import 'dart:math' show pi;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scaler/back/entity/day.dart';
import 'package:scaler/back/entity/plan.dart';
import 'package:scaler/back/service/day_service.dart';
import 'package:scaler/back/service/plan_service.dart';
import 'package:scaler/global/global.dart';
import 'package:scaler/global/theme_data.dart';
import 'package:scaler/page/calendar_page/calendar_plan.dart';
import 'package:scaler/widget/bar_popup_menu_button.dart';
import 'package:scaler/widget/drawer_widget.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:toggle_rotate/toggle_rotate.dart';

import 'calendar_event.dart';

import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';

import 'edit_log_page.dart';

// Example holidays
final Map<DateTime, List> _holidays = {
  DateTime(2019, 1, 1): ['New Year\'s Day'],
  DateTime(2019, 1, 6): ['Epiphany'],
  DateTime(2019, 2, 14): ['Valentine\'s Day'],
  DateTime(2019, 4, 21): ['Easter Sunday'],
  DateTime(2019, 4, 22): ['Easter Monday'],
};

class CalendarPage extends StatefulWidget {
  CalendarPage({Key key, this.title}) : super(key: key);

  final String title;

  static CalendarController _calendarController;

  @override
  _CalendarPageState createState() => _CalendarPageState();

  static DateTime getSelectedDay() {
    return _calendarController.selectedDay;
  }
}

class _CalendarPageState extends State<CalendarPage>
    with TickerProviderStateMixin {
  AnimationController _animationController;

  @override
  void initState() {
    CalendarPage._calendarController = CalendarController();
//    CalendarPage._calendarController.setCalendarFormat(CalendarFormat.month);

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _animationController.forward();

    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    CalendarPage._calendarController.dispose();
    super.dispose();
  }

  Future<void> _onDaySelected(DateTime date, List events) async {
    context.read<Global>().setSelectedDate(DayService.getDayTime(date));
    Day day = await DayService.setDay(date);
    context.read<Global>().setSelectedDay(day);
    List<Plan> plans = await PlanService.findListByDay(day);
    plans = PlanService.listOrderById(plans);
    setState(() {
      context.read<Global>().setPlans(plans);
      context.read<Global>().setSelectedEvents(events);
      context.read<Global>().setLog(day.log);
    });
  }

  void _onVisibleDaysChanged(
      DateTime first, DateTime last, CalendarFormat format) {}

  void _onCalendarCreated(
      DateTime first, DateTime last, CalendarFormat format) {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('calendar'),
        actions: <Widget>[
          BarPopupMenuButton(),
        ],
      ),
      drawer: DrawerWidget(),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          // Switch out 2 lines below to play with TableCalendar's settings
          //-----------------------
          TableCalendar(
            initialCalendarFormat: CalendarFormat.week,
            availableCalendarFormats: {
              CalendarFormat.week: 'Month',
              CalendarFormat.month: 'Week',
            },
            calendarController: CalendarPage._calendarController,
            events: context.watch<Global>().events,
            holidays: _holidays,
            startingDayOfWeek: StartingDayOfWeek.monday,
            calendarStyle: CalendarStyle(
              selectedColor: TD.selectedColor,
              todayColor: TD.todayColor,
              markersColor: TD.markersColor,

//              outsideWeekendStyle: TextStyle(
//                  color: Colors.cyan[200]
//              ),
//              weekendStyle: TextStyle(
//                  color: Colors.cyan
//              ),
              outsideDaysVisible: true,
            ),
            headerStyle: HeaderStyle(
              formatButtonTextStyle:
                  TextStyle().copyWith(color: Colors.white, fontSize: 15.0),
              formatButtonDecoration: BoxDecoration(
                color: TD.td.accentColor,
                borderRadius: BorderRadius.circular(16.0),
              ),
            ),
            onDaySelected: _onDaySelected,
            onVisibleDaysChanged: _onVisibleDaysChanged,
            onCalendarCreated: _onCalendarCreated,
          ),
          // _buildTableCalendarWithBuilders(),
          const SizedBox(height: 8.0),
          _buildButtons(),
          const SizedBox(height: 8.0),
          Expanded(child: _buildList())
        ],
      ),
    );
  }

  Widget _buildButtons() {
    final dateTime = DateTime.now();

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
      child: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.centerLeft,
            child: RaisedButton(
              child: Text(
                'Set day ${dateTime.day}-${dateTime.month}-${dateTime.year}',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                CalendarPage._calendarController.setSelectedDay(
                  DateTime(dateTime.year, dateTime.month, dateTime.day),
                  runCallback: true,
                );
              },
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: ToggleRotate(
              rad: pi,
              curve: Curves.linear,
              child:
                  Icon(Icons.arrow_drop_down, size: 50, color: TD.td.accentColor),
              onTap: () {
                setState(() {
                  if (CalendarPage._calendarController.calendarFormat ==
                      CalendarFormat.month) {
                    CalendarPage._calendarController
                        .setCalendarFormat(CalendarFormat.week);
                  } else {
                    CalendarPage._calendarController
                        .setCalendarFormat(CalendarFormat.month);
                  }
                });
              }, //点击事件
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildList() {
    List<Widget> _totalList = <Widget>[];

    Widget _planItem;
    List<Widget> _planList = <Widget>[];
    context.watch<Global>().plans.forEach((plan) {
      _planList.add(CalendarPlan(
        plan: plan,
      ));
      _planList.add(Divider());
    });
    if (_planList.length != 0) {
      _planList.removeLast();
      _planItem = Container(
          margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          child: ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: Container(
//            margin: const EdgeInsetsDirectional.only(start: 2, end: 2, top: 2, bottom: 2),
                decoration: BoxDecoration(
                  color: TD.contentColor, // BorderRadius
                ),
                child: Column(
                  children: _planList,
                ),
              )));
    } else {
      _planItem = _getNothingWidget('No plan for the day!');
    }

    List<Widget> _eventList = context.watch<Global>().selectedEvents.map((e) {
      return CalendarEvent(event: e);
    }).toList();
    if (_eventList.length == 0)
      _eventList = [_getNothingWidget('No event for the day!')];

    List<Widget> _logList = <Widget>[
      Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
      ),
      Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 0.0),
        decoration: BoxDecoration(
          color: TD.logFrameColor,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(15.0),
            topRight: const Radius.circular(15.0),
          ), // BorderRadius
        ), // BoxDecoration
        child: Container(
          margin: const EdgeInsetsDirectional.only(start: 2, end: 2, top: 2),
          decoration: BoxDecoration(
            color: TD.logBackgroundColor,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(12.0),
              topRight: const Radius.circular(12.0),
            ), // BorderRadius
          ),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
            child: Text(_getLog()),
          ), // BoxDecoration
        ), // Container
      ), // Container
      Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 0.0),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            bottomLeft: const Radius.circular(12.0),
            bottomRight: const Radius.circular(12.0),
          ),
          child: Container(
            color: TD.logFrameColor,
            child: FlatButton(
              onPressed: () {
                final myNotifier = Provider.of<Global>(context, listen: false);

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return ChangeNotifierProvider.value(
                      value: myNotifier,
                      child: EditLogPage(),
                    );
                  }),
                );
              },
              child: Text('Edit',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
      ),
      Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      ),
    ];

    _totalList
      ..add(_planItem)
      ..addAll(_eventList)
      ..addAll(_logList);

    return ListView(children: _totalList);
  }

  Widget _getNothingWidget(String text) {

    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        child: ClipRRect(
            borderRadius: BorderRadius.circular(12.0),
            child: Container(
//            margin: const EdgeInsetsDirectional.only(start: 2, end: 2, top: 2, bottom: 2),
              decoration: BoxDecoration(
                color: TD.contentColor, // BorderRadius
              ),
              child: ListTile(
                title: Text(text),
              ),
            )));
  }

  String _getLog() {
    if (context.watch<Global>().log.length != 0)
      return context.watch<Global>().log;
    else
      return 'No log for the day!';
  }
}
