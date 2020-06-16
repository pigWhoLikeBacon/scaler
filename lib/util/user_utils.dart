import 'package:scaler/web/cookie_action.dart';

import '../global/config.dart';

class UserUtils {
  static bool isLogin() {
    List<String> cookies = CookieAction.get();
    if (cookies == null) return false;

    String username = Config.get(config_username);

    Map<String, String> map = CookieAction.cookieListToMap(cookies);
    if (map['remember-me'] != null && username.length != 0) return true;
    else return false;
  }
}