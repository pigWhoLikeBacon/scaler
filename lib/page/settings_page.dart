import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scaler/global/config.dart';
import 'package:scaler/global/theme_data.dart';
import 'package:scaler/util/dialog_utils.dart';


class SettingsPage extends StatefulWidget {
  SettingsPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String _baseUrl;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Settings",
          textScaleFactor: Config.get(config_textScaleFactor),
        ),
      ),
      body: SingleChildScrollView(
          child: SafeArea(
        child: ListBody(
          children: <Widget>[
            Container(
              height: 10.0,
            ),
            ListTile(
              leading: Icon(Icons.account_box),
              title: Text(
                'Logout',
                textScaleFactor: Config.get(config_textScaleFactor),
              ),
              subtitle: Text(
                'Clear local user and cookie',
                textScaleFactor: Config.get(config_textScaleFactor),
              ),
              onTap: () {
                _logout();
              },
            ),
            Divider(height: 20.0),
            ListTile(
              title: Text('Boy next door!'),
              trailing: CupertinoSwitch(
                activeColor: Colors.deepOrange[400],
                value: Config.get(config_themeKey) == 'dark' ? true : false, //当前状态
                onChanged: (value) {
                  _changeBrightness();
                },
              ),
            ),
            Container(height: 10.0,),
            Divider(height: 0),
            ExpansionTile(
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: 10,),
                    Container(height: 10.0,),
                    Text('Base url:   ' + Config.get(config_baseUrl)),
                    SizedBox(height: 10,),
                    Container(height: 10.0,),
                  ],
                ),
                initiallyExpanded: false,
                children: <Widget> [
                  Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        ListTile(
                          title: TextFormField(
                            initialValue: Config.get(config_baseUrl),
                            maxLines: 3,
                            minLines: 1,
                            decoration: InputDecoration(labelText: 'BaseUrl'),
                            validator: (val) =>
                            val.length < 1 ? 'Content Required' : null,
                            onSaved: (val) => _baseUrl = val,
                            obscureText: false,
                            keyboardType: TextInputType.text,
                            autocorrect: false,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      FlatButton(
                          child: Text('Edit'),
                          onPressed: () {
                            _editBaseUrl();
                          })
                    ],
                  ),
                ],
            ),
            Divider(height: 0),
            Container(height: 10.0,),
            ListTile(
              title: Text('Reset Settings'),
              onTap: () {
                _reset();
              },
            ),
          ],
        ),
      )),
    );
  }

  void _logout() {
    setState(() {
      Config.logout();
    });
  }

  void _editBaseUrl() {
    _formKey.currentState.save();
    setState(() {
      Config.set(config_baseUrl, _baseUrl);
    });
  }

  void _changeBrightness() {
    if (Theme.of(context).brightness != Brightness.light) {
      setState(() {
        Config.set(config_themeKey, 'light');
        TD.init();
        DynamicTheme.of(context).setThemeData(TD.td);
      });
    } else {
      setState(() {
        Config.set(config_themeKey, 'dark');
        TD.init();
        DynamicTheme.of(context).setThemeData(TD.td);
      });
    }
  }

  void _reset() {
    setState(() {
      Config.initDeleteConfigs();
      DynamicTheme.of(context).setThemeData(TD.td);
    });
  }
}
