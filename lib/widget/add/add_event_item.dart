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
                      GestureDetector(
                        onTap: () {
                          DatePicker.showDateTimePicker(context,
                              showTitleActions: true,
                              minTime: DateTime(2018, 3, 5),
                              maxTime: DateTime(2019, 6, 7),
                              onConfirm: (date) {
                                print('confirm $date');
                              },
                              currentTime: DateTime.now(),
                              locale: LocaleType.en);
                        },
                        child: Text(
                          'show date time picker (Chinese)',
                          style: TextStyle(color: Colors.blue),
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
