import 'package:dio/dio.dart';

import 'back/database/db.dart';
import 'back/entity/day.dart';
import 'back/entity/day_plan.dart';
import 'back/entity/event.dart';
import 'back/entity/plan.dart';

t3() async {
  await DB.init();

  print(await DB.save('plan', Plan(null, 'hhd1')));
  print(await DB.query('plan'));
  print(await DB.save('plan', Plan(1, 'hhd2')));
  print(await DB.query('plan'));

  print(await DB.findById('plan', 1));

  print(await DB.deleteById('plan', 1));
  print(await DB.query('plan'));

  //
  print(1);

  print(await DB.save(tableDay, Day(null, 'date', 'log')));
  print(await DB.save(tableEvent, Event(null, 3, '00:00:00', 'content')));
  print(await DB.save(tablePlan, Plan(null, 'content')));
  print(await DB.save(tableDayPlan, DayPlan(null, 1, 2, true)));
  print(await DB.query(tableDay));
  print(await DB.query(tableEvent));
  print(await DB.query(tablePlan));
  print(await DB.query(tableDayPlan));
}

t4() async {
  try {
    Response response = await Dio().get("http://129.211.9.152:8081/downdata");
    print(response);
  } catch (e) {
    print(e);
  }
}

t5() async {
  try {
    Response response;
    Dio dio = new Dio();

    FormData formData = FormData.fromMap({"username": "pig", "password": "123456 ", "remember-me": "on"});

    response = await dio.post("http://129.211.9.152:8081/login",
        data: formData,
    );
    print('!!!');
    print(response);
  } catch (e) {
    RequestOptions ro = e.request;
    print(ro.headers);
    print(ro.data.toString());
    
    // The request was made and the server responded with a status code
    // that falls out of the range of 2xx and is also not 304.
    if (e.response != null) {
      print(e.response.data);
      print(e.response.headers);
      print(e.response.request);
    } else {
      // Something happened in setting up or sending the request that triggered an Error
      print(e.request);
      print(e.message);
    }
  }
}
