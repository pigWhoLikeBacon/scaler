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
    print("ERROR[${err?.response?.statusCode}] => PATH: ${err?.request?.path}");
    if (err?.response == null)  ToastUtils.show('Connection fail!');
    else ToastUtils.show(err.response.data.toString());
    return super.onError(err);
  }
}
