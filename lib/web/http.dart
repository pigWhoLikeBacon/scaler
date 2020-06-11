import 'package:dio/dio.dart';
import 'package:scaler/global/config.dart';

import 'custom_interceptors.dart';

//Http Client
abstract class HC {
  static Dio dio;

  static init() {
    dio = Dio(BaseOptions(
      baseUrl: Config.get(config_baseUrl),
      connectTimeout: Config.get(config_connectTimeout),
      receiveTimeout: Config.get(config_receiveTimeout),
      validateStatus: (status) {
        bool cond1 = status == 200;
        bool cond2 = status == 401;
        bool cond3 = status == 403;
        if (cond1 || cond2 || cond3)
          return true;
        else
          return false;
      },
    ));
    dio.interceptors.add(CustomInterceptors());
  }

  static Options _getCookieOptions() {
    return Options(headers: {'cookie': Config.get(config_cookie)});
  }

  static _saveCookie(List<String> cookies) {
    Config.set(config_cookie, cookies);
  }

//  static Future<Response> get(String url, bool saveCookie) async {
//    print(2);
//    Response response = await dio.get(url, options: _getCookieOptions());
//    if (saveCookie) _saveCookie(_getCookieFromResponse(response));
//    return response;
//  }
//
//  static Future<Response> post(String url, FormData formData, bool saveCookie) async {
//    print(2);
//    Response response = await dio.post(url, data: formData);
////    if (saveCookie) _saveCookie(_getCookieFromResponse(response));
//    return response;
//  }

  static Dio getDio() {
    return dio;
  }
}
