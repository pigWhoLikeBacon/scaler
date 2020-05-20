import 'package:scaler/back/database/sp.dart';

var a = List<String>();

const Map<String, dynamic> Configs = {
  'textScaleFactor' : 1.0,
  'themeKey' : 'light',
  'username' : '',
  'cookie' : null,
  'baseUrl' : 'http://129.211.9.152:8081',
  'connectTimeout' : 5000,
  'receiveTimeout' : 100000,
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