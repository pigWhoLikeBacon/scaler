import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scaler/global/config.dart';
import 'package:scaler/global/theme_data.dart';


class SettingsPage extends StatefulWidget {
  SettingsPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

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
                'Stay Logged In',
                textScaleFactor: Config.get(config_textScaleFactor),
              ),
              subtitle: Text(
                'Logout from the Main Menu',
                textScaleFactor: Config.get(config_textScaleFactor),
              ),
            ),
            Divider(height: 20.0),
            ListTile(
              title: Text('Boy next door!'),
              trailing: CupertinoSwitch(
                activeColor: Colors.deepOrange[400],
                value: Config.get(config_themeKey) == 'dark' ? true : false, //当前状态
                onChanged: (value) {
                  changeBrightness();
                },
              ),
            ),
            Divider(height: 20.0),
            ListTile(
              title: Text('Reset Settings'),
              onTap: () {
                setState(() {
                  Config.initDeleteConfigs();
                  DynamicTheme.of(context).setThemeData(TD.td);
                });
              },
            ),
          ],
        ),
      )),
    );
  }

  void changeBrightness() {
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
}
