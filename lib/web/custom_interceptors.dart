import 'package:dio/dio.dart';
import 'package:scaler/util/toast_utils.dart';
import 'package:scaler/web/cookie_action.dart';

class CustomInterceptors extends InterceptorsWrapper {
  @override
  Future onRequest(RequestOptions options) {
    print("REQUEST[${options?.method}] => PATH: ${options?.path}");
    return super.onRequest(options);
  }

  @override
  Future onResponse(Response response) {
    print("RESPONSE[${response?.statusCode}] => PATH: ${response?.request?.path}");
    CookieAction.set(response);



    return super.onResponse(response);
  }

  @override
  Future onError(DioError err) {
    int statusCode = err?.response?.statusCode;

    print("ERROR[$statusCode] => PATH: ${err?.request?.path}");
//    if (statusCode == 403 || statusCode == 401) {
//      print(1);
//      print(err.response.data.toString());
//      ToastUtils.show(err.response.data.toString());
////      return onResponse(err?.response);
//    } else if (err?.response == null) {
//      print(2);
//      ToastUtils.show('Connection fail!');
////      return onResponse(err?.response);
//    } else {
//      print(3);
//      return super.onError(err);
//    }
  }
}
