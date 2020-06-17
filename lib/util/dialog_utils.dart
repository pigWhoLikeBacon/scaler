import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_dialog/flutter_custom_dialog.dart';
import 'package:scaler/global/config.dart';
import 'package:scaler/global/theme_data.dart';
import 'package:scaler/widget/color_loader_2.dart';

class DialogUtils {
//  static Future<void> showMyDialog(BuildContext context) async {
//    return showDialog<void>(
//      context: context,
//      barrierDismissible: false, // user must tap button!
//      builder: (BuildContext context) {
//        return AlertDialog(
//          title: Text('AlertDialog Title'),
//          content: SingleChildScrollView(
//            child: ListBody(
//              children: <Widget>[
//                Text('This is a demo alert dialog.'),
//                Text('Would you like to approve of this message?'),
//              ],
//            ),
//          ),
//          actions: <Widget>[
//            FlatButton(
//              child: Text('Approve'),
//              onPressed: () {
//                Navigator.of(context).pop();
//              },
//            ),
//          ],
//        );
//      },
//    );
//  }

  static Future<void> showLoader(BuildContext context, String text) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return UnconstrainedBox(
            constrainedAxis: Axis.vertical,
            child: SizedBox(
                width: 240.0,
                height: 240.0,
                child: AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20.0))),
                  content: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        new Padding(padding: const EdgeInsets.only(top: 10.0)),
                        Config.get(config_themeKey) == 'light'
                            ? new CircularProgressIndicator()
                            : ColorLoader2(
                                color1: Colors.redAccent,
                                color2: Colors.deepPurple,
                                color3: Colors.green,
                              ),
                        new Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: new Text(text),
                        ),
                      ],
                    ),
                  ),
                )));
      },
    );
  }

  static YYDialog YYAlertDialog(String text) {
    return YYDialog().build()
      ..width = 220
      ..borderRadius = 4.0
      ..text(
        padding: EdgeInsets.all(25.0),
        alignment: Alignment.center,
        text: text,
        color: Colors.black,
        fontSize: 14.0,
        fontWeight: FontWeight.w500,
      )
      ..divider()
      ..doubleButton(
        padding: EdgeInsets.only(top: 10.0),
        gravity: Gravity.center,
        withDivider: true,
        text1: "OK",
        color1: Colors.redAccent,
        fontSize1: 14.0,
        fontWeight1: FontWeight.bold,
        onTap1: () {
          print("OK");
        },
      )
      ..show();
  }

//  static void showTextDialog(BuildContext context, String text) {
//    var dialog = CupertinoAlertDialog(
//      content: Text(
//        text,
//        style: TextStyle(fontSize: 20),
//      ),
//      actions: <Widget>[
//        CupertinoButton(
//          child: Text("OK"),
//          onPressed: () {
//            Navigator.pop(context);
//          },
//        ),
//      ],
//    );
//
//    showDialog(context: context, builder: (_) => dialog);
//  }

  static YYDialog editYYBottomSheetDialog(String text, Function function) {
    YYDialog dialog = YYDialog();

    return dialog.build()
      ..gravity = Gravity.bottom
      ..gravityAnimationEnable = true
      ..backgroundColor = Colors.transparent
      ..widget(Container(
        margin: EdgeInsets.only(bottom: 10),
        child: MaterialButton(
          minWidth: 300,
          height: 45,
          color: TD.td.cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
          ),
          child: Text(text, style: TextStyle(color: Colors.red)),
          onPressed: () async {
            await function();
            dialog.dismiss();
          },
        ),
      ))
      ..widget(Container(
        margin: EdgeInsets.only(bottom: 20),
        child: MaterialButton(
          minWidth: 300,
          height: 45,
          color: TD.td.cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
          ),
          child: Text('Cancel'),
          onPressed: () {
            dialog.dismiss();
          },
        ),
      ))
      ..show();
  }
}
