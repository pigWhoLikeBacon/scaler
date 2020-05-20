import 'dart:io';

import 'package:dio/dio.dart';
import 'package:scaler/config/config.dart';

class CookieAction {

  //Get the saved cookie.
  static List<String> get() {
    return Config.get('cookie') == null ? null : List.from(Config.get('cookie'));
  }

  //Get cookie from response and save it.
  static set(Response response) {
    List<String> newCookies = _getCookieFromResponse(response);
    List<String> oldCookies = get();

    List<String> cookies = _addCookies(oldCookies, newCookies);
    _saveCookie(cookies);
  }

  static List<String> _getCookieFromResponse(Response response) {
    List<String> cookies = response.headers['set-cookie'];
    return cookies;
  }

  static _saveCookie(List<String> cookies) {
    Config.set('cookie', cookies);
  }

  static List<String> _addCookies(List<String> oldCookies, List<String> newCookies) {
    if (oldCookies == null) return newCookies;
    if (newCookies == null) return oldCookies;

    Map<String, String> oldMap = cookieListToMap(oldCookies);
    Map<String, String> newMap = cookieListToMap(newCookies);

    newMap.forEach((key, value) {
      oldMap[key] = value;
    });

    return cookieMapToList(oldMap);
  }

  static Map<String, String> cookieListToMap(List<String> cookies) {
    if (cookies == null) return null;
    Map<String, String> map = Map();
    cookies.forEach((s) {
      Cookie c = Cookie.fromSetCookieValue(s);
      map[c.name] = s;
    });
    return map;
  }

  static List<String> cookieMapToList(Map<String, String> map) {
    if (map == null) return null;
    List<String> cookies = List();
    map.forEach((key, value) {
      cookies.add(value);
    });
    return cookies;
  }
}