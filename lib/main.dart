import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flare_splash_screen/flare_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jpush_flutter/jpush_flutter.dart';
import 'package:provider/provider.dart';
import 'package:scaler/tab_navigator.dart';
import 'package:scaler/util/aync_utils.dart';
import 'package:scaler/util/background_fetch_utils.dart';
import 'package:scaler/util/jpush_utils.dart';
import 'package:scaler/web/http.dart';
import 'package:scaler/widget/restart_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'back/database/db.dart';
import 'back/database/sp.dart';
import 'back/service/day_service.dart';
import 'global/config.dart';
import 'global/global.dart';
import 'global/theme_data.dart';
import 'util/jpush_utils.dart';

void main() async {
  init();
  runApp(MyApp());
}

Future<void> init() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SP.init();
  await DB.init();
  Config.init();
  TD.init();
  await HC.init();
  await DayService.initDays();
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
//    initPlatformState();
  }

  //目前 flutter push 插件还不够完善，所以以后再加入push功能

  // Platform messages are asynchronous, so we initialize in an async method.
//  Future<void> initPlatformState() async {
//    String platformVersion;
//
//    try {
//      JPushUtils.jpush.addEventHandler(
//          onReceiveNotification: (Map<String, dynamic> message) async {
//        print("flutter onReceiveNotification: $message");
//      }, onOpenNotification: (Map<String, dynamic> message) async {
//        print("flutter onOpenNotification: $message");
//      }, onReceiveMessage: (Map<String, dynamic> message) async {
//        print("flutter onReceiveMessage: $message");
//      }, onReceiveNotificationAuthorization:
//              (Map<String, dynamic> message) async {
//        print("flutter onReceiveNotificationAuthorization: $message");
//      });
//    } on PlatformException {
//      platformVersion = 'Failed to get platform version.';
//      print(platformVersion);
//    }
//
//    JPushUtils.jpush.setup(
////      appKey: "e58a32cb3e4469ebf31867e5", //你自己应用的 AppKey
//      channel: "theChannel",
//      production: false,
//      debug: true,
//    );
//    JPushUtils.jpush.applyPushAuthority(
//        new NotificationSettingsIOS(sound: true, alert: true, badge: true));
//
//    // Platform messages may fail, so we use a try/catch PlatformException.
//    JPushUtils.jpush.getRegistrationID().then((rid) {
//      print("flutter get registration id : $rid");
//    });
//
//    // If the widget was removed from the tree while the asynchronous platform
//    // message was in flight, we want to discard the reply rather than calling
//    // setState to update our non-existent appearance.
//    if (!mounted) return;
//
//    // 三秒后出发本地推送
//    var fireDate = DateTime.fromMillisecondsSinceEpoch(
//        DateTime.now().millisecondsSinceEpoch + 10000);
//    var localNotification = LocalNotification(
//        id: 234,
//        title: '1',
//        buildId: 1,
//        content: '1',
//        fireTime: fireDate,
//        subtitle: '1',
//        badge: 5,
//        extra: {"fa": "0"});
//    JPushUtils.jpush.sendLocalNotification(localNotification).then((res) {
//      print(res);
//    });
//
//    JPushUtils.clear();
//
//    localNotification = LocalNotification(
//        id: 235,
//        title: '2',
//        buildId: 1,
//        content: '2',
//        fireTime: fireDate,
//        subtitle: '2',
//        badge: 5,
//        extra: {"fa": "0"});
//    JPushUtils.jpush.sendLocalNotification(localNotification).then((res) {
//      print(res);
//    });
//
//    JPushUtils.jpush.sendLocalNotification(localNotification).then((res) {
//      print(res);
//    });
//  }

  @override
  Widget build(BuildContext context) {
    return RestartWidget(
        child: DynamicTheme(
            data: (brightness) => TD.td,
            themedWidgetBuilder: (context, theme) {
              return MaterialApp(
                theme: theme,
                home: Scaffold(
                    resizeToAvoidBottomPadding: false,
                    body: SplashScreen.navigate(
                      name: 'assets/intro.flr',
                      next: (_) {
                        return MultiProvider(
                          providers: [
                            ChangeNotifierProvider(create: (_) => Global()),
                          ],
                          child: TabNavigator(),
                        );
                      },
                      until: () => Future.delayed(Duration(seconds: 3)),
                      startAnimation: '1',
                      backgroundColor: Colors.blue,
                    )),
              );
            }));
  }
}
