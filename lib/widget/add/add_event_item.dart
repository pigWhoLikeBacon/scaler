import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:scaler/back/database/db.dart';
import 'package:scaler/back/entity/day.dart';
import 'package:scaler/back/entity/event.dart';
import 'package:scaler/back/service/day_service.dart';
import 'package:scaler/global/global.dart';
import 'package:scaler/global/theme_data.dart';
import 'package:scaler/navigator/tab_navigator.dart';
import 'package:scaler/util/dialog_utils.dart';
import 'package:scaler/widget/simple_round_button.dart';

// ignore_for_file: public_member_api_docs, lines_longer_than_80_chars
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';

class AddEventItem extends StatefulWidget {
  AddEventItem();

  AddEventItemState createState() => AddEventItemState();
}

class AddEventItemState extends State<AddEventItem> {
  String _content;
  DateTime _dateTime;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _dateTime = DateTime.now();

    super.initState();
  }

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
                        Divider(),
                        FlatButton(
                          onPressed: () {
                            DatePicker.showDateTimePicker(context,
                                showTitleActions: true,
                                minTime: DateTime(2019, 3, 5),
                                maxTime: DateTime(2021, 6, 7),
                                onConfirm: (data) {
                              setState(() {
                                _dateTime = data;
                              });
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
    FocusScope.of(context).requestFocus(FocusNode());
    DialogUtils.showLoader(context, 'Adding...');

    String info = '';
    _formKey.currentState.save();

    Day day = await DayService.setDay(_dateTime);
    String time = formatDate(_dateTime, [HH, ':', nn, ':', ss]);
    DateTime date = DateTime(_dateTime.year, _dateTime.month, _dateTime.day);
    Event event = new Event(null, day.id, time, _content);

    try {
      event.id = await DB.save(tableEvent, event);
      info = 'Successfully added!';
    } catch (e) {
      info = 'Error' + e.toString();
      throw e;
    }

    setState(() {
      Map<DateTime, List> events = context.read<Global>().events;

      events.update(
        date,
        (previousEvents) => previousEvents..add(event),
        ifAbsent: () => [event],
      );

      context.read<Global>().setEvents(events);
      context.read<Global>().setSelectedEvents(
          events[context.read<Global>().selectedDate] ??
              []);
    });

    Navigator.of(context).pop();
    DialogUtils.showTextDialog(context, info);
    dropdownMenuController.hide();
//    print(await DB.query(tableEvent));
  }
}
