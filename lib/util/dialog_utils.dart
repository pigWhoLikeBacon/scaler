import 'package:flutter/material.dart';
import 'package:scaler/config/config.dart';
import 'package:scaler/config/theme_data.dart';
import 'package:scaler/widget/color_loader_2.dart';

class DialogUtils {
  static Future<void> showMyDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('AlertDialog Title'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('This is a demo alert dialog.'),
                Text('Would you like to approve of this message?'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Approve'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  static Future<void> showLoader(BuildContext context, String text) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return UnconstrainedBox(
            constrainedAxis: Axis.vertical,
            child: SizedBox(
                width: 240.0,
                height: 240.0,
                child: AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20.0))),
                  content: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        new Padding(padding: const EdgeInsets.only(top: 10.0)),
                        Config.get('themeKey') == 'light'
                            ? new CircularProgressIndicator()
                            : ColorLoader2(
                                color1: Colors.redAccent,
                                color2: Colors.deepPurple,
                                color3: Colors.green,
                              ),
                        new Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: new Text(text),
                        ),
                      ],
                    ),
                  ),
                )));
      },
    );
  }

  static Future<void> showAdd(BuildContext context, int currentIndex) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Icon(
            Icons.event,
            size: 30.0,
            color: themes[Config.get('themeKey')].accentColor,
            semanticLabel: 'hhd',
          ),
          content: SafeArea(
            child: ListView(
              physics: AlwaysScrollableScrollPhysics(),
              key: PageStorageKey("Divider 2"),
              children: <Widget>[
                Form(
//                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ListTile(
                        title: TextFormField(
                          initialValue: Config.get('username'),
                          decoration: InputDecoration(labelText: '1'),
                          validator: (val) =>
                              val.length < 1 ? 'Username Required' : null,
//                          onSaved: (val) => _username = val,
                          obscureText: false,
                          keyboardType: TextInputType.text,
                          autocorrect: false,
                        ),
                      ),
                      ListTile(
                        title: TextFormField(
                          decoration: InputDecoration(labelText: '2'),
                          validator: (val) =>
                              val.length < 1 ? 'Password Required' : null,
//                          onSaved: (val) => _password = val,
                          obscureText: true,
                          keyboardType: TextInputType.text,
                          autocorrect: false,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Approve'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
