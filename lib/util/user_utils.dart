import 'package:scaler/config/config.dart';
import 'package:scaler/web/cookie_action.dart';

class UserUtils {
  static bool isLogin() {
    List<String> cookies = CookieAction.get();
    if (cookies == null) return false;

    Map<String, String> map = CookieAction.cookieListToMap(cookies);
    if (map['remember-me'] != null) return true;
    else return false;
  }
}