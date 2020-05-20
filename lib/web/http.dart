import 'package:dio/dio.dart';
import 'package:scaler/config/config.dart';

import 'custom_interceptors.dart';

//Http Client
abstract class HC {
  static Dio dio;

  static init() {
    dio = Dio(BaseOptions(
      baseUrl: Config.get('baseUrl'),
      connectTimeout: Config.get('connectTimeout'),
      receiveTimeout: Config.get('receiveTimeout'),
      validateStatus: (status) {
        if (status == 200 || status == 302) {
          return true;
        } else {
          return false;
        }
      },
    ));
    dio.interceptors.add(CustomInterceptors());
  }

  static Options _getCookieOptions() {
    return Options(headers: {'cookie': Config.get('cookie')});
  }

  static _saveCookie(List<String> cookies) {
    Config.set('cookie', cookies);
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
