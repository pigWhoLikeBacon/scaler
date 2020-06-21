import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scaler/global/config.dart';
import 'package:scaler/page/login_page.dart';
import 'package:scaler/page/settings_page.dart';
import 'package:scaler/util/toast_utils.dart';
import 'package:scaler/util/user_utils.dart';

import '../global/config.dart';


class DrawerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
//    final _auth = Provider.of<AuthModel>(context, listen: true);
    return Drawer(
      child: SafeArea(
        // color: Colors.grey[50],
        child: ListView(
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.account_circle),
              title: Text(
                UserUtils.isLogin() ? Config.get(config_username) : 'Login',
                textScaleFactor: Config.get(config_textScaleFactor),
                maxLines: 1,
              ),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LoginPage()));
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text(
                'Settings',
                textScaleFactor: Config.get(config_textScaleFactor),
              ),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SettingsPage()));
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.arrow_back),
              title: Text(
                'Logout',
                textScaleFactor: Config.get(config_textScaleFactor),
              ),
              onTap: () {
                Config.logout();
                ToastUtils.show('Logout success!');
                },
            ),
          ],
        ),
      ),
    );
  }
}
