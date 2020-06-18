import 'package:dio/dio.dart';
import 'package:scaler/back/service/aync_service.dart';
import 'package:scaler/util/toast_utils.dart';
import 'package:scaler/web/http.dart';
import 'dart:convert' as convert;

class AyncUtils {
  static Future<Response> downloadDataAndSave() async {
    Response response = await HC.get('/downdata');
    Map<String, dynamic> map = Map<String, dynamic>();
    if (response?.statusCode == 200) {
      Map<String, dynamic> map2 = Map<String, dynamic>.from(response?.data);
//      print("map['data']");
//      print(map['data']);
      map = convert.jsonDecode(map2['data']);
      return await AyncService.saveServiceData(map);
    } else {
      return null;
    }
  }

  static Future<Response> uploadData() async {
    return await HC.post("/updata", data: await AyncService.getLocalData());
  }

  static Future<Map<String, dynamic>> _getServiceData() async {
    Response response = await HC.get('/downdata');
    if (response?.statusCode == 200) {
      Map<String, dynamic> map = Map<String, dynamic>.from(response?.data);
      Map<String, dynamic> map2 = convert.jsonDecode(map['data']);
      return map2;
    } else {
      return null;
    }
  }
}