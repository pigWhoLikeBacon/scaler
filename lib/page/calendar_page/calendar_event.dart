import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:scaler/back/database/db.dart';
import 'package:scaler/back/entity/day.dart';
import 'package:scaler/back/entity/event.dart';
import 'package:scaler/back/service/day_service.dart';
import 'package:scaler/back/service/event_service.dart';
import 'package:scaler/global/global.dart';
import 'package:scaler/util/dialog_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:scaler/util/toast_utils.dart';

import '../../global/theme_data.dart';

class CalendarEvent extends StatefulWidget {
  final Event event;

  const CalendarEvent({Key key, this.event}) : super(key: key);

  CalendarEventState createState() => CalendarEventState();
}

class CalendarEventState extends State<CalendarEvent> {
  Event _event;
  DateTime _dateTime;
  String _content;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _loadData();
    super.initState();
  }

  _loadData() {
    _event = widget.event;
    DateTime selectedDay = context.read<Global>().selectedDate;
    _dateTime = DateTime.parse(
        formatDate(selectedDay, [yyyy, '-', mm, '-', dd]) + ' ' + _event.time);
  }

  @override
  Widget build(BuildContext context) {
    _event = widget.event;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child:
        ClipRRect(
            borderRadius: BorderRadius.circular(12.0),
          child: Container(
//            margin: const EdgeInsetsDirectional.only(start: 2, end: 2, top: 2, bottom: 2),
            decoration: BoxDecoration(
              color: TD.td.cardColor, // BorderRadius
            ),
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
                    Text(_event.content),
                  ],
                ),
//            onTap: () => print('$event tapped!'),
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text('Start Time'),
                                  SizedBox(
                                    height: 6,
                                    width: 1,
                                  ),
                                  Text(formatDate(_dateTime, [
                                    yyyy,
                                    '-',
                                    mm,
                                    '-',
                                    dd,
                                    ' ',
                                    HH,
                                    ':',
                                    nn,
                                    ':',
                                    ss
                                  ])),
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
                            _delete();
                          });
                        }),
                    FlatButton(
                        child: Text('Edit'),
                        onPressed: () {
                          DialogUtils.editYYBottomSheetDialog(
                              'Edit this item permanently', () {
                            _edit();
                          });
                        })
                  ],
                )
              ],
            ),
          )),
    );
  }

  _delete() async {
    await EventService.deleteById(_event.id);
    ToastUtils.show('Delete successful! ID: ' + _event.id.toString());

    setState(() {
      Map<DateTime, List> events = context.read<Global>().events;

      events[context.read<Global>().selectedDate].removeWhere((element) {
        Event event = element;
        bool flag = event.id == _event.id;
        print(flag);
        return flag;
      });

      context.read<Global>().setEvents(events);
    });
  }

  _edit() async {
    //删除该event
    await EventService.deleteById(_event.id);

    //添加修改完毕的事件
    _formKey.currentState.save();

    Day day = await DayService.setDay(_dateTime);
    String time = formatDate(_dateTime, [HH, ':', nn, ':', ss]);
    Event newEvent = new Event(null, day.id, time, _content);
    newEvent.id = await DB.save(tableEvent, newEvent);
    ToastUtils.show('Edit successful! ID: ' + newEvent.id.toString());

    setState(() {
      Map<DateTime, List> events = context.read<Global>().events;

      //删除events
      events[context.read<Global>().selectedDate].removeWhere((element) {
        Event event = element;
        bool flag = event.id == _event.id;
        print(flag);
        return flag;
      });

      context.read<Global>().setEvents(events);

      //添加更新完毕的events
      events.update(
        DayService.getDayTime(_dateTime),
        (previousEvents) => previousEvents..add(newEvent),
        ifAbsent: () => [newEvent],
      );

      context.read<Global>().setEvents(events);
      context
          .read<Global>()
          .setSelectedEvents(events[context.read<Global>().selectedDate] ?? []);
    });
  }
}
