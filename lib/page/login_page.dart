import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:scaler/global/config.dart';
import 'package:scaler/global/theme_data.dart';
import 'package:scaler/util/aync_utils.dart';
import 'package:scaler/util/dialog_utils.dart';
import 'package:scaler/util/toast_utils.dart';
import 'package:scaler/web/http.dart';

class LoginPage extends StatefulWidget {
  final String username;

  LoginPage({this.username});

  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  String _username, _password;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
//    final _auth = Provider.of<AuthModel>(context, listen: true);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Login",
          textScaleFactor: Config.get(config_textScaleFactor),
        ),
      ),
      body: SafeArea(
        child: ListView(
          physics: AlwaysScrollableScrollPhysics(),
          key: PageStorageKey("Divider 1"),
          children: <Widget>[
            SizedBox(
              height: 220.0,
              child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Icon(
                    Icons.person,
                    size: 175.0,
                  )),
            ),
            Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ListTile(
                    title: TextFormField(
                      initialValue: Config.get(config_username),
                      decoration: InputDecoration(labelText: 'Username'),
                      validator: (val) =>
                          val.length < 1 ? 'Username Required' : null,
                      onSaved: (val) => _username = val,
                      obscureText: false,
                      keyboardType: TextInputType.text,
                      autocorrect: false,
                    ),
                  ),
                  ListTile(
                    title: TextFormField(
                      decoration: InputDecoration(labelText: 'Password'),
                      validator: (val) =>
                          val.length < 1 ? 'Password Required' : null,
                      onSaved: (val) => _password = val,
                      obscureText: true,
                      keyboardType: TextInputType.text,
                      autocorrect: false,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              title: RaisedButton(
                child: Text(
                  'Login',
                  style: TextStyle(color: TD.td.selectedRowColor),
                  textScaleFactor: Config.get(config_textScaleFactor),
                ),
                onPressed: () async {
                  // Validate will return true if the form is valid, or false if
                  // the form is invalid.
                  if (_formKey.currentState.validate()) {
                    await login();
                  }
                },
              ),
            ),
            FlatButton(
              child: Text(
                'Need an Account?',
                textScaleFactor: Config.get(config_textScaleFactor),
              ),
              onPressed: () {
                ToastUtils.show('This service is not yet enabled!');
              },
            ),
          ],
        ),
      ),
    );
  }

  login() async {
    DialogUtils.showLoader(context, 'Login...');

    _formKey.currentState.save();
    setState(() {
      Config.set(config_username, _username);
    });

    FormData formData = new FormData.fromMap({
      "username": _username,
      "password": _password,
      "remember-me": 'on',
    });

    Response response = await HC.post("/login", data: formData);

    if (response?.statusCode == 200) {
      ToastUtils.show(response?.data.toString());
      Navigator.of(context)..pop()..pop()..pop();
    }
    else Navigator.of(context).pop();
  }
}
