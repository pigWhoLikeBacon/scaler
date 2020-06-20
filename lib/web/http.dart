import 'package:dio/dio.dart';
import 'package:scaler/global/config.dart';

import 'custom_interceptors.dart';

//Http Client
abstract class HC {
  static Dio _dio;

  static init() {
    _dio = Dio(BaseOptions(
      baseUrl: Config.get(config_baseUrl),
      connectTimeout: Config.get(config_connectTimeout),
      receiveTimeout: Config.get(config_receiveTimeout),
//      contentType: Headers.formUrlEncodedContentType,
      validateStatus: (status) {
//        print(status);

        bool cond1 = status == 200;
        bool cond2 = status == 302;
        bool cond3 = status == 401;
        bool cond4 = status == 403;
        if (cond1 || cond2 || cond3 || cond4)
          return true;
        else
          return false;
      },
    ));
//    dio.options.contentType = Headers.formUrlEncodedContentType;
    _dio.interceptors.add(CustomInterceptors());
  }

  static Future<Response> get(String url) async {
    try {
      Response response = await HC._dio.get(url);
      return response;
    } catch (e) {
      print(e);
      return null;
    }
  }

  static Future<Response> post(String url, {data}) async {
    try {
      Response response = await HC._dio.post(url, data: data);
      return response;
    } catch (e) {
      print(e);
      return null;
    }
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
}
