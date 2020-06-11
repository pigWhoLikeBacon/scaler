import 'dart:io';

import 'package:dio/dio.dart';
import 'package:scaler/global/config.dart';

class CookieAction {
  static RequestOptions getCookieOptions(RequestOptions options) {
//    options.headers.addAll({'Cookie': getCookieString()});
    options.headers.addAll({'Cookie':
    'JSESSIONID=F19726114AF0F055DAC93DA96461949B; remember-me=Yk9Dczg2OFUlMkZtSnRhQ1Y2aFVVJTJCdkElM0QlM0Q6S1haTjFJQnVWNyUyRk02OW9SMGVVWmFBJTNEJTNE; '});
//    print(getCookieString());
    return options;
  }

  static String getCookieString() {
    String cookieString = '';
    List<String> cookies = Config.get(config_cookie) == null ? [] : List.from(Config.get(config_cookie));
    cookies.forEach((e) {
      cookieString += e + '; ';
    });
//    if (cookieString.length != 0)
//      cookieString = cookieString.substring(0, cookieString.length - 1);
    return cookieString;
  }

  //Get the saved cookie.
  static List<String> get() {
    return Config.get(config_cookie) == null
        ? null
        : List.from(Config.get(config_cookie));
  }

  //Get cookie from response and save it.
  static save(Response response) {
    List<String> newCookies = _getCookieFromResponse(response);
    List<String> oldCookies = get();

    List<String> cookies = _addCookies(oldCookies, newCookies);
    _saveCookie(cookies);
  }

  static List<String> _getCookieFromResponse(Response response) {
    List<String> cookies = response.headers['set-cookie'];
    print(cookies);
    return cookies;
  }

  static _saveCookie(List<String> cookies) {
    Config.set(config_cookie, cookies);
  }

  static List<String> _addCookies(
      List<String> oldCookies, List<String> newCookies) {
    if (oldCookies == null) return newCookies;
    if (newCookies == null) return oldCookies;

    Map<String, String> oldMap = cookieListToMap(oldCookies);
    Map<String, String> newMap = cookieListToMap(newCookies);

    newMap.forEach((key, value) {
      oldMap[key] = value;
    });

    return cookieMapToList(oldMap);
  }

  // 将 cookies 从 list 转换为 map， 并且去掉无用的参数
  static Map<String, String> cookieListToMap(List<String> cookies) {
    if (cookies == null) return null;
    Map<String, String> map = Map();
    cookies.forEach((s) {
      Cookie c = Cookie.fromSetCookieValue(s);
      map[c.name] = c.value;
    });
    return map;
  }

  static List<String> cookieMapToList(Map<String, String> map) {
    if (map == null) return null;
    List<String> cookies = List();
    map.forEach((key, value) {
      cookies.add(key + '=' + value);
    });
    return cookies;
  }
}
