import 'package:dio/dio.dart';
import 'package:scaler/back/service/aync_service.dart';
import 'package:scaler/util/toast_utils.dart';
import 'package:scaler/web/http.dart';
import 'dart:convert' as convert;

class AyncUtils {
  static downloadDataAndSave() async {
    Map<String, dynamic> map = await _getServiceData();
    if (map != null) {
//      try {
//        AyncService.saveServiceData(map);
//        ToastUtils.show('Save success!');
//      } catch (e) {
//        ToastUtils.show('Save error!');
//        print(e);
//      }
      await AyncService.saveServiceData(map);
    }
    print(map);
  }

  static uploadData() async {
    await HC.post("/updata", data: await AyncService.getLocalData());
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