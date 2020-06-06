import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:scaler/back/database/db.dart';
import 'package:scaler/back/entity/day.dart';
import 'package:scaler/back/service/day_service.dart';
import 'package:scaler/global/global.dart';
import 'package:scaler/util/dialog_utils.dart';
import 'package:provider/provider.dart';


class EditLogPage extends StatefulWidget {
  @override
  _EditLogPageState createState() => _EditLogPageState();
}

class _EditLogPageState extends State<EditLogPage> {
  String _content;
  DateTime _date;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _date = context.read<Global>().selectedDate;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Log'),
        centerTitle: true,
        actions: <Widget>[
          FlatButton(
            child: Text('Edit'),
            textColor: Colors.white70,
            onPressed: () {
              _edit();
            },
          ),
        ],
      ),
      body: Center(
        child: Container(
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
                        DatePicker.showDatePicker(context,
                            showTitleActions: true,
                            minTime: DateTime.now().add(new Duration(days: -3 * 365)),
                            maxTime: DateTime.now(),
                            onConfirm: (data) {
                              setState(() {
                                _date = data;
                                print(_date);
                              });
                            },
                            currentTime: _date,
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
                                Text(formatDate(_date, [yyyy, '-', mm, '-', dd])),
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
                        maxLines: 12,
                        minLines: 1,
                        initialValue: context.watch<Global>().log,
                        decoration: InputDecoration(labelText: 'Content'),
                        validator: (val) => val.length < 1 ? 'Content Required' : null,
                        onSaved: (val) => _content = val,
                        obscureText: false,
                        keyboardType: TextInputType.text,
                        autocorrect: false,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        )
      ),
    );
  }

  _edit() async {
    DialogUtils.showLoader(context, 'Editing...');

    _formKey.currentState.save();
    Day day = await DayService.setDay(_date);
    day.log = _content;

    String info = '';

    try {
      day.id = await DB.save(tableDay, day);
      info = 'Successfully edited!';
    } catch (e) {
      info = 'Error:' + e.toString();
      throw e;
    }

    if (DayService.getDayTime(_date) == context.read<Global>().selectedDate) {
      context.read<Global>().setLog(day.log);
    }

    Navigator.of(context).pop();
    DialogUtils.showTextDialog(context, 'Successfully edited!');
//    print(await DB.query(tableDay));
  }
}
