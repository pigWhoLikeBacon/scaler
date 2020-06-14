import 'package:dio/dio.dart';
import 'package:scaler/back/database/db.dart';
import 'package:scaler/back/entity/day.dart';
import 'package:scaler/back/entity/day_plan.dart';
import 'package:scaler/back/entity/event.dart';
import 'package:scaler/back/entity/plan.dart';
import 'package:scaler/back/service/aync_service.dart';
import 'package:scaler/web/http.dart';

class AyncUtils {
  static downloadDataAndSave() async {
    Map<String, dynamic> map = await _getServiceData();
    if (map != null) {

    }
    print(map);
  }

  static uploadData() async {
    await HC.post("http://192.168.123.79:8081/updata", data: await AyncService.getLocalData());
  }

  static Future<Map<String, dynamic>> _getServiceData() async {
    Response response = await HC.get('http://192.168.123.79:8081/downdata');
    if (response?.statusCode == 200) {
      Map<String, dynamic> map = Map<String, dynamic>.from(response?.data);
      return map;
    } else {
      return null;
    }
  }
}