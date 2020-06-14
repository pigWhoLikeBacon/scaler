import 'package:flutter/material.dart';
import 'package:scaler/back/service/aync_service.dart';
import 'package:scaler/navigator/tab_navigator.dart';
import 'package:scaler/util/aync_utils.dart';
import 'package:scaler/util/dialog_utils.dart';

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
            AyncUtils.uploadData();
            DialogUtils.showLoader(context, 'Uploading...');
            await AyncUtils.uploadData();
            Navigator.of(context).pop();
            break;
          }
          case '1': {
            DialogUtils.showLoader(context, 'Loading and rebuilding...');
            await AyncUtils.downloadDataAndSave();
            await TabNavigator.loadData(context);
            Navigator.of(context).pop();
            break;
          }
        }
      },
    );
  }
}
