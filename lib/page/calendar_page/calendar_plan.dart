import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:scaler/back/database/db.dart';
import 'package:scaler/back/entity/day.dart';
import 'package:scaler/back/entity/event.dart';
import 'package:scaler/back/entity/plan.dart';
import 'package:scaler/back/service/day_service.dart';
import 'package:scaler/back/service/event_service.dart';
import 'package:scaler/global/global.dart';
import 'package:scaler/util/dialog_utils.dart';

// ignore_for_file: public_member_api_docs, lines_longer_than_80_chars
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';

class CalendarPlan extends StatefulWidget {
  final  Plan plan;

  const CalendarPlan({Key key, this.plan}) : super(key: key);

  CalendarPlanState createState() => CalendarPlanState();
}

class CalendarPlanState extends State<CalendarPlan> {
  Plan _plan;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _plan = widget.plan;

    return Container(
      child: ListTile(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(_plan.content),
            Icon(Icons.check_circle),
          ],
        ),
        onTap: () => print('$_plan tapped!'),
      ),
    );
  }
}
