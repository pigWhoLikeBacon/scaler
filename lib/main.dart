import 'dart:async';

import 'package:dio/dio.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flare_splash_screen/flare_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';
import 'package:scaler/navigator/tab_navigator.dart';
import 'package:scaler/util/aync_utils.dart';
import 'package:scaler/web/http.dart';
import 'package:scaler/widget/restart_widget.dart';

import 'back/database/db.dart';
import 'back/database/sp.dart';
import 'back/service/day_service.dart';
import 'global/config.dart';
import 'global/global.dart';
import 'global/theme_data.dart';

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
