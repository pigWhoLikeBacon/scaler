import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:scaler/back/database/db.dart';
import 'package:scaler/back/entity/day.dart';
import 'package:scaler/back/entity/event.dart';
import 'package:scaler/back/service/day_service.dart';
import 'package:scaler/global/theme_data.dart';
import 'package:scaler/util/dialog_utils.dart';
import 'package:scaler/widget/simple_round_button.dart';

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
                                },
                                currentTime: _dateTime,
                                locale: LocaleType.en);
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
                                    SizedBox(height: 6, width: 1,),
                                    Text(formatDate(_dateTime, [yyyy, '-', mm, '-', dd, ' ', HH, ':', nn, ':', ss])),
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
    DialogUtils.showLoader(context, 'Adding...');

    try {
      _formKey.currentState.save();

      Day day = await DayService.setDay(_dateTime);
      String time = formatDate(_dateTime, [HH, ':', nn, ':', ss]);
      Event event = new Event(null, day.id, time, _content);
      await DB.save(tableEvent, event);

      Navigator.of(context).pop();
      DialogUtils.showTextDialog(context, 'Successfully added!');
    } catch (e) {
      Navigator.of(context).pop();
      DialogUtils.showTextDialog(context, 'Error' + e.toString());
      throw e;
    }

//    print(await DB.query(tableEvent));
  }
}
