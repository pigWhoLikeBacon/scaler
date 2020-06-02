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

// ignore_for_file: public_member_api_docs, lines_longer_than_80_chars
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DateTimePickerWrappr extends StatefulWidget {
  final Event event;

  const DateTimePickerWrappr({Key key, this.event}) : super(key: key);

  DateTimePickerWrapprState createState() => DateTimePickerWrapprState();
}

class DateTimePickerWrapprState extends State<DateTimePickerWrappr> {
  Event _event;
  DateTime _dateTime;
  String _content;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {

    _event = widget.event;
    _dateTime = DateTime.parse(formatDate(global_selectedDay, [yyyy, '-', mm, '-', dd]) + ' ' + _event.time);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                      int id = await EventService.deleteById(_event.id);
                      DialogUtils.showTextDialog(
                          context, 'Delete successful! ID: ' + id.toString());
                      print('global_events:' + context.read<Global>().events.toString());
                      setState(() {
                        Map<DateTime, List> events = context.read<Global>().events;
                        events[global_selectedDay].removeWhere((e) {
                          Event event = e;
                          print(event.toJson());
                          print('e.id:' + event.id.toString());
                          print('_event.id:' + _event.id.toString());
                          print(event.id == _event.id);
                          return event.id == _event.id;
                        });

                        events[global_selectedDay].forEach((e) {
                          Event event = e;
                          print(event.toJson());
                        });

                        context.read<Global>().setEvents(events);
                      });
                      print('global_events:' + context.read<Global>().events.toString());
                    }),
//                FlatButton(
//                    child: Text('Edit'),
//                    onPressed: () async {
//                      print('edit');
//
//                      //删除该event
//                      await EventService.deleteById(_event.id);
//
//                      //添加修改完毕的事件
//                      _formKey.currentState.save();
//
//                      Day day = await DayService.setDay(_dateTime);
//                      String time =
//                      formatDate(_dateTime, [HH, ':', nn, ':', ss]);
//                      Event newEvent =
//                      new Event(null, day.id, time, _content);
//                      newEvent.id = await DB.save(tableEvent, _event);
//
//                      DialogUtils.showTextDialog(context, 'Edit successful!');
//
//                      setState(() {
//                        global_events[global_selectedDay]
//                            .removeWhere((e) => e.id == _event.id);
//                        global_events[DateTime.parse(day.date)].add(newEvent);
//                      });
//
//                      print('global_events:' + global_events.toString());
//                    })
              ],
            )
          ],
        ));
  }
}
