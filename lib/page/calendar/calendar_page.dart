import 'dart:math' show pi;

import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:scaler/back/database/db.dart';
import 'package:scaler/back/entity/day.dart';
import 'package:scaler/back/entity/event.dart';
import 'package:scaler/back/entity/plan.dart';
import 'package:scaler/back/service/day_service.dart';
import 'package:scaler/back/service/event_service.dart';
import 'package:scaler/back/service/plan_service.dart';
import 'package:scaler/config/theme_data.dart';
import 'package:scaler/page/edit_log_page.dart';
import 'package:scaler/util/dialog_utils.dart';
import 'package:scaler/widget/drawer_widget.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:toggle_rotate/toggle_rotate.dart';

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
  DateTime _selectedDay;
  List<Plan> _plans = [];
  // _events中的key，DateTime统一为当天12点整
  Map<DateTime, List> _events;
  List _selectedEvents;
  AnimationController _animationController;

  @override
  void initState() {
    _selectedEvents = [];
    _loadData();

    CalendarPage._calendarController = CalendarController();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _animationController.forward();

    super.initState();
  }

  _loadData() async {
    _selectedDay =
        DateTime.parse(formatDate(DateTime.now(), [yyyy, '-', mm, '-', dd]));

    Day day = await DayService.setDay(_selectedDay);
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

    setState(() {
      _plans = plans;
      _events = events;
      _selectedEvents = _events[_selectedDay] ?? [];
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    CalendarPage._calendarController.dispose();
    super.dispose();
  }

  Future<void> _onDaySelected(DateTime date, List events) async {
    _selectedDay = date;
    Day day = await DayService.setDay(date);
    List<Plan> plans = await PlanService.findListByDay(day);
    plans = PlanService.listOrderById(plans);

    print('CALLBACK: _onDaySelected,date: ' + day.date);
    setState(() {
      _plans = plans;
      _selectedEvents = events;
    });
  }

  void _onVisibleDaysChanged(
      DateTime first, DateTime last, CalendarFormat format) {
    print('CALLBACK: _onVisibleDaysChanged');
  }

  void _onCalendarCreated(
      DateTime first, DateTime last, CalendarFormat format) {
    print('CALLBACK: _onCalendarCreated');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('calendar'),
      ),
      drawer: DrawerWidget(),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          // Switch out 2 lines below to play with TableCalendar's settings
          //-----------------------
          _buildTableCalendar(),
          // _buildTableCalendarWithBuilders(),
          const SizedBox(height: 8.0),
          _buildButtons(),
          const SizedBox(height: 8.0),
          Expanded(child: _buildList())
        ],
      ),
    );
  }

  // Simple TableCalendar configuration (using Styles)
  Widget _buildTableCalendar() {
    return TableCalendar(
      calendarController: CalendarPage._calendarController,
      events: _events,
      holidays: _holidays,
      startingDayOfWeek: StartingDayOfWeek.monday,
      calendarStyle: CalendarStyle(
        selectedColor: Colors.deepOrange[400],
        todayColor: Colors.deepOrange[200],
        markersColor: Colors.brown[700],
        outsideDaysVisible: false,
      ),
      headerStyle: HeaderStyle(
        formatButtonTextStyle:
            TextStyle().copyWith(color: Colors.white, fontSize: 15.0),
        formatButtonDecoration: BoxDecoration(
          color: Colors.deepOrange[400],
          borderRadius: BorderRadius.circular(16.0),
        ),
      ),
      onDaySelected: _onDaySelected,
      onVisibleDaysChanged: _onVisibleDaysChanged,
      onCalendarCreated: _onCalendarCreated,
    );
  }

  // More advanced TableCalendar configuration (using Builders & Styles)
  Widget _buildTableCalendarWithBuilders() {
    return TableCalendar(
      locale: 'pl_PL',
      calendarController: CalendarPage._calendarController,
      events: _events,
      holidays: _holidays,
      initialCalendarFormat: CalendarFormat.month,
      formatAnimation: FormatAnimation.slide,
      startingDayOfWeek: StartingDayOfWeek.sunday,
      availableGestures: AvailableGestures.all,
      availableCalendarFormats: const {
        CalendarFormat.month: '',
        CalendarFormat.week: '',
      },
      calendarStyle: CalendarStyle(
        outsideDaysVisible: false,
        weekendStyle: TextStyle().copyWith(color: Colors.blue[800]),
        holidayStyle: TextStyle().copyWith(color: Colors.blue[800]),
      ),
      daysOfWeekStyle: DaysOfWeekStyle(
        weekendStyle: TextStyle().copyWith(color: Colors.blue[600]),
      ),
      headerStyle: HeaderStyle(
        centerHeaderTitle: true,
        formatButtonVisible: false,
      ),
      builders: CalendarBuilders(
        selectedDayBuilder: (context, date, _) {
          return FadeTransition(
            opacity: Tween(begin: 0.0, end: 1.0).animate(_animationController),
            child: Container(
              margin: const EdgeInsets.all(4.0),
              padding: const EdgeInsets.only(top: 5.0, left: 6.0),
              color: Colors.deepOrange[300],
              width: 100,
              height: 100,
              child: Text(
                '${date.day}',
                style: TextStyle().copyWith(fontSize: 16.0),
              ),
            ),
          );
        },
        todayDayBuilder: (context, date, _) {
          return Container(
            margin: const EdgeInsets.all(4.0),
            padding: const EdgeInsets.only(top: 5.0, left: 6.0),
            color: Colors.amber[400],
            width: 100,
            height: 100,
            child: Text(
              '${date.day}',
              style: TextStyle().copyWith(fontSize: 16.0),
            ),
          );
        },
        markersBuilder: (context, date, events, holidays) {
          final children = <Widget>[];

          if (events.isNotEmpty) {
            children.add(
              Positioned(
                right: 1,
                bottom: 1,
                child: _buildEventsMarker(date, events),
              ),
            );
          }

          if (holidays.isNotEmpty) {
            children.add(
              Positioned(
                right: -2,
                top: -2,
                child: _buildHolidaysMarker(),
              ),
            );
          }

          return children;
        },
      ),
      onDaySelected: (date, events) {
        _onDaySelected(date, events);
        _animationController.forward(from: 0.0);
      },
      onVisibleDaysChanged: _onVisibleDaysChanged,
      onCalendarCreated: _onCalendarCreated,
    );
  }

  Widget _buildEventsMarker(DateTime date, List events) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: CalendarPage._calendarController.isSelected(date)
            ? Colors.brown[500]
            : CalendarPage._calendarController.isToday(date)
                ? Colors.brown[300]
                : Colors.blue[400],
      ),
      width: 16.0,
      height: 16.0,
      child: Center(
        child: Text(
          '${events.length}',
          style: TextStyle().copyWith(
            color: Colors.white,
            fontSize: 12.0,
          ),
        ),
      ),
    );
  }

  Widget _buildHolidaysMarker() {
    return Icon(
      Icons.add_box,
      size: 20.0,
      color: Colors.blueGrey[800],
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
                  'Set day ${dateTime.day}-${dateTime.month}-${dateTime.year}'),
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
              child: Icon(Icons.arrow_drop_up,
                  size: 50, color: Colors.orangeAccent),
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

    List<Widget> _planList = <Widget>[];
    _plans.forEach((plan) {
      _planList.add(Container(
        child: ListTile(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(plan.content),
              Icon(Icons.check_circle),
            ],
          ),
          onTap: () => print('$plan tapped!'),
        ),
      ));
      _planList.add(Divider());
    });
    if (_planList.length != 0) _planList.removeLast();
    Widget _planItem = Container(
      decoration: BoxDecoration(
        border: Border.all(width: 0.8),
        borderRadius: BorderRadius.circular(12.0),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Column(
        children: _planList,
      ),
    );

    List<Widget> _eventList = _selectedEvents.map((e) {
      Event event = e;

      String _content;
      DateTime _dateTime = DateTime.parse(formatDate(_selectedDay, [yyyy, '-', mm, '-', dd]) + ' ' + event.time);

      final _formKey = GlobalKey<FormState>();

      return Container(
          decoration: BoxDecoration(
            border: Border.all(width: 0.8),
            borderRadius: BorderRadius.circular(12.0),
          ),
          margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          child: ExpansionTile(
            title: ListTile(
              title: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(formatDate(_dateTime,
                      [yyyy, '-', mm, '-', dd, ' ', HH, ':', nn, ':', ss])),
                  SizedBox(
                    height: 6,
                    width: 1,
                  ),
                  Text(event.content),
                ],
              ),
              onTap: () => print('$event tapped!'),
            ),
            children: <Widget>[
              Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Divider(),
                    FlatButton(
                      onPressed: () {
                        DatePicker.showDateTimePicker(context,
                            showTitleActions: true,
                            minTime: DateTime(2019, 3, 5),
                            maxTime: DateTime(2021, 6, 7), onConfirm: (data) {
                          setState(() {
                            _dateTime = data;
                          });
                          print(_dateTime);
                        }, currentTime: _dateTime, locale: LocaleType.en);
                      },
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(6, 0, 10, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text('Start Time'),
                                SizedBox(
                                  height: 6,
                                  width: 1,
                                ),
                                Text(formatDate(_dateTime,
                                    [yyyy, '-', mm, '-', dd, ' ', HH, ':', nn, ':', ss])),
                              ],
                            ),
                            Icon(Icons.arrow_forward_ios),
                          ],
                        ),
                      ),
                    ),
                    Divider(),
                    ListTile(
                      title: TextFormField(
//                        initialValue: Config.get('username'),
                        maxLines: 3,
                        minLines: 1,
                        decoration: InputDecoration(labelText: 'Content'),
                        validator: (val) =>
                            val.length < 1 ? 'Content Required' : null,
//                        onSaved: (val) => _content = val,
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
                      onPressed: () async {
                        print('delete');
                        int id = await EventService.deleteById(event.id);
                        DialogUtils.showTextDialog(
                            context, 'Delete successful! ID: ' + id.toString());
                        setState(() {
                          _events[_selectedDay]
                              .removeWhere((e) => e.id == event.id);
                        });
                      }),
                  FlatButton(
                      child: Text('Edit'),
                      onPressed: () async {
                        print('edit');

                        //删除该event
                        await EventService.deleteById(event.id);

                        //添加修改完毕的事件
                        _formKey.currentState.save();

                        Day day = await DayService.setDay(_dateTime);
                        String time =
                            formatDate(_dateTime, [HH, ':', nn, ':', ss]);
                        Event newEvent =
                            new Event(null, day.id, time, _content);
                        newEvent.id = await DB.save(tableEvent, event);

                        DialogUtils.showTextDialog(context, 'Edit successful!');

                        setState(() {
                          _events[_selectedDay]
                              .removeWhere((e) => e.id == event.id);
                          _events[DateTime.parse(day.date)].add(newEvent);
                        });
                      })
                ],
              )
            ],
          ));
    }).toList();

    List<Widget> _logList = <Widget>[
      Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
      ),
      Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 0.0),
        decoration: BoxDecoration(
          color: Colors.orange,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(15.0),
            topRight: const Radius.circular(15.0),
          ), // BorderRadius
        ), // BoxDecoration
        child: Container(
          margin: const EdgeInsetsDirectional.only(start: 2, end: 2, top: 2),
          decoration: BoxDecoration(
            color: TD.td.cardColor,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(12.0),
              topRight: const Radius.circular(12.0),
            ), // BorderRadius
          ),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
            child: Text('data'),
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
            color: Colors.cyan,
            child: FlatButton(
              onPressed: () {
                print('hhd');
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => EditLogPage()));
              },
              child: Text('hhd'),
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
}
