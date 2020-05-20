import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:scaler/config/config.dart';
import 'package:scaler/config/theme_data.dart';
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
          textScaleFactor: Config.get('textScaleFactor'),
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
                      initialValue: Config.get('username'),
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
                  style: TextStyle(
                      color: themes[Config.get('themeKey')].selectedRowColor),
                  textScaleFactor: Config.get('textScaleFactor'),
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
                textScaleFactor: Config.get('textScaleFactor'),
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
      Config.set('username', _username);
    });

    FormData formData = new FormData.fromMap({
      "username": _username,
      "password": _password,
      "remember-me": 'on',
    });

    try {
      await HC.getDio()
          .post("http://129.211.9.152:8081/login", data: formData);
      Navigator.of(context)..pop()..pop()..pop();
      ToastUtils.show('Login success!');
    } catch (e) {
      Navigator.of(context).pop();
      throw e;
    }
  }
}
