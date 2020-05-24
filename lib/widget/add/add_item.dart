import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:scaler/config/theme_data.dart';
import 'package:scaler/widget/simple_round_button.dart';

class AddEventItem extends StatefulWidget {
  AddEventItem();

  AddEventItemState createState() => AddEventItemState();
}

class AddEventItemState extends State<AddEventItem> {
  String _username, _password;
  DateTime _time;

  final _formKey = GlobalKey<FormState>();

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
                                minTime: DateTime(2018, 3, 5),
                                maxTime: DateTime(2019, 6, 7),
                                onConfirm: (date) {
                                  print('confirm $date');
                                  _time = date;
                                },
                                currentTime: DateTime.now(),
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
                                    Text(_time.toString()),
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
                            onSaved: (val) => _username = val,
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
                  print(TD.td.accentColor);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
