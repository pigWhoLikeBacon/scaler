import 'package:dio/dio.dart';
import 'package:scaler/back/database/db.dart';
import 'package:scaler/back/entity/day.dart';
import 'package:scaler/back/entity/day_plan.dart';
import 'package:scaler/back/entity/event.dart';
import 'package:scaler/back/entity/plan.dart';
import 'package:scaler/back/service/aync_service.dart';
import 'package:scaler/web/http.dart';

class AyncUtils {
  static downloadDataAndSave() {}

  static uploadData() async {
    await HC.getDio().post("http://192.168.123.79:8081/updata", data: await AyncService.getLocalData());
  }

  static Future<Map<String, dynamic>> getServiceData() async {
    Response response = await HC.getDio().get('http://192.168.123.79:8081/downdata');
    Map<String, dynamic> map = Map<String, dynamic>.from(response.data);
    return map;
  }
}