import 'package:dio/dio.dart';
import 'package:scaler/util/toast_utils.dart';
import 'package:scaler/web/cookie_action.dart';

class CustomInterceptors extends InterceptorsWrapper {
  @override
  Future onRequest(RequestOptions options) {
    print("REQUEST[${options?.method}] => PATH: ${options?.path}");

    options = CookieAction.getCookieOptions(options);

    return super.onRequest(options);
  }

  @override
  Future onResponse(Response response) {
    int statusCode = response?.statusCode;

    print("RESPONSE[${response?.statusCode}] => PATH: ${response?.request?.path}");
    CookieAction.save(response);

    ToastUtils.show(response?.data.toString());
    print(response?.data.toString());

//    bool cond1 = statusCode == 302;
//    bool cond2 = statusCode == 401;
//    bool cond3 = statusCode == 403;
//    if (cond1 || cond2 || cond3) {
//      ToastUtils.show(response?.data.toString());
//    }

//    print('response.request.headers.toString()!!!!!!!!!!!!!!!!!!!!!!!!!!!');
//    print(response.request.headers.toString());
//    print('response.headers.toString()!!!!!!!!!!!!!!!!!!!!!!!!!!!');
//    print(response.headers.toString());

    return super.onResponse(response);
  }

  @override
  Future onError(DioError err) {
    int statusCode = err?.response?.statusCode;

//    print('response.request.headers.toString()!!!!!!!!!!!!!!!!!!!!!!!!!!!');
//    print(err.response.request.headers.toString());
//    print('response.request.headers.data!!!!!!!!!!!!!!!!!!!!!!!!!!!');
//    print(err.response.request.data);
//    print('response.headers.toString()!!!!!!!!!!!!!!!!!!!!!!!!!!!');
//    print(err.response.headers.toString());

    print("ERROR[${err?.response?.statusCode}] => PATH: ${err?.request?.path}");
    if (err?.response == null)  ToastUtils.show('Connection fail!');
    else {
      print(err.response.data.toString());
      ToastUtils.show(err.response.data.toString());
    }
    return super.onError(err);
  }
}
