import 'package:scaler/back/database/sp.dart';

const String config_textScaleFactor = 'textScaleFactor';
const String config_themeKey = 'themeKey';
const String config_username = 'username';
const String config_cookie = 'cookie';
const String config_baseUrl = 'baseUrl';
const String config_connectTimeout = 'connectTimeout';
const String config_receiveTimeout = 'receiveTimeout';

const Map<String, dynamic> Configs = {
  config_textScaleFactor : 1.0,
  config_themeKey : 'light',
  config_username : '',
  config_cookie : null,
  config_baseUrl : 'http://192.168.123.79:8081',
  config_connectTimeout : 5000,
  config_receiveTimeout : 100000,
};

abstract class Config {
  static var _configs;

  static init() {
    _configs = Map.from(Configs);
    var tempConfigs = Map.from(Configs);

    _configs.forEach((key, value) {
      dynamic t = SP.get(key);
      if (t != null) {
        tempConfigs[key] = t;
      }
    });

    _configs = Map.from(tempConfigs);
  }

  static get(String key) {
    return _configs[key];
  }

  static set(String key, dynamic value) {
    SP.save(key, value);
    init();
  }

  static initDeleteConfigs() {
    Configs.forEach((key, value) {
      SP.remove(key);
    });
    init();
  }
}