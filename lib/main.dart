import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flare_splash_screen/flare_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:scaler/navigator/tab_navigator.dart';
import 'package:scaler/web/http.dart';

import 'back/database/db.dart';
import 'back/database/sp.dart';
import 'back/service/day_service.dart';
import 'config/config.dart';
import 'config/theme_data.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SP.init();
  await DB.init();
  Config.init();
  TD.init();
  await HC.init();
  await DayService.setDay(DateTime.now());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return RestartWidget(
        child: DynamicTheme(
            data: (brightness) => themes[Config.get('themeKey')],
            themedWidgetBuilder: (context, theme) {
              return MaterialApp(
                theme: theme,
                home: Scaffold(
                    resizeToAvoidBottomPadding: false,
                    body: SplashScreen.navigate(
                      name: 'assets/intro.flr',
                      next: (_) {
//                        return LoadingProvider(
//                          themeData: LoadingThemeData(
//                             tapDismiss: false,
//                            animDuration: Duration(
//                              milliseconds: Config.get('connectTimeout')
//                            ),
//                          ),
//                          loadingWidgetBuilder: (ctx, data) {
//                            return LoaderWidget();
//                          },
//                          child: TabNavigator(),
//                        );
                        return TabNavigator();
                      },
                      until: () => Future.delayed(Duration(seconds: 3)),
                      startAnimation: '1',
                      backgroundColor: Colors.blue,
                    )),
              );
            }));
  }
}

///这个组件用来重新加载整个child Widget的。当我们需要重启APP的时候，可以使用这个方案
///https://stackoverflow.com/questions/50115311/flutter-how-to-force-an-application-restart-in-production-mode
class RestartWidget extends StatefulWidget {
  final Widget child;

  RestartWidget({Key key, @required this.child})
      : assert(child != null),
        super(key: key);

  static restartApp(BuildContext context) {
    final _RestartWidgetState state =
        context.ancestorStateOfType(const TypeMatcher<_RestartWidgetState>());
    state.restartApp();
  }

  @override
  _RestartWidgetState createState() => _RestartWidgetState();
}

class _RestartWidgetState extends State<RestartWidget> {
  Key key = UniqueKey();

  void restartApp() {
    setState(() {
      key = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      key: key,
      child: widget.child,
    );
  }
}
