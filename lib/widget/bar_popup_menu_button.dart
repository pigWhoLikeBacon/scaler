import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:scaler/back/service/aync_service.dart';
import 'package:scaler/util/aync_utils.dart';
import 'package:scaler/util/dialog_utils.dart';

import '../tab_navigator.dart';
import '../util/toast_utils.dart';

class BarPopupMenuButton extends StatelessWidget {

  SelectView(IconData icon, String text, String id) {
    return new PopupMenuItem<String>(
        value: id,
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            new Icon(icon, color: Colors.blue),
            new Text(text),
          ],
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return new PopupMenuButton<String>(

      itemBuilder: (BuildContext context) => <PopupMenuItem<String>>[
        this.SelectView(Icons.arrow_upward, 'Upload Data     ', '0'),
        this.SelectView(Icons.arrow_downward, 'Download Data', '1'),
      ],
      onSelected: (String action) async {
        // 点击选项的时候
        switch (action) {
          case '0': {
            DialogUtils.editYYBottomSheetDialog(
                'Delete this item permanently', () async {
              DialogUtils.showLoader(context, 'Uploading...');
              AyncUtils.uploadData();
              Response response = await AyncUtils.uploadData();
              if (response?.statusCode == 200)
                ToastUtils.show(response?.data.toString());
              Navigator.of(context).pop();
            });
            break;
          }
          case '1': {
            DialogUtils.editYYBottomSheetDialog(
                'Delete this item permanently', () async {
              DialogUtils.showLoader(context, 'Loading and rebuilding...');
              Response response = await AyncUtils.downloadDataAndSave();
              await TabNavigator.loadData(context);
              if (response?.statusCode == 200)
                ToastUtils.show(response?.data.toString());
              Navigator.of(context).pop();
            });
            break;
          }
        }
      },
    );
  }
}
