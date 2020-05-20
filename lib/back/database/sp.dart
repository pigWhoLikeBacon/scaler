import 'package:shared_preferences/shared_preferences.dart';

abstract class SP {
  static SharedPreferences _sp;

  static Future<void> init() async {
    if (_sp == null) {
      try {
        _sp = await SharedPreferences.getInstance();
      } catch (e) {
        print(e);
      }
    }
    return _sp;
  }

  static void save(String key, dynamic value) {
    if (value is String) _sp.setString(key, value);
    if (value is bool) _sp.setBool(key, value);
    if (value is int) _sp.setInt(key, value);
    if (value is double) _sp.setDouble(key, value);
    if (value is List<String>) _sp.setStringList(key, value);
  }

  static dynamic get(String key) {
    return _sp.get(key);
  }

  static dynamic remove(String key) {
    return _sp.remove(key);
  }

  static void clear() {
    _sp.clear();
  }

  static void t() async {
    save('1', 1);
    save('themeKey', 'dark');
    print('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!');
    print(_sp.get('1'));
    print(_sp.get('2'));
    print(_sp.get('ThemeKey'));
    print('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!');

//    clear();
    print('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!');
    print(_sp.get('1'));
    print(_sp.get('2'));
    print('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!');
  }
}
