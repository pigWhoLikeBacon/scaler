import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screen_scaler/flutter_screen_scaler.dart';
import 'package:gzx_dropdown_menu/gzx_dropdown_menu.dart';

import 'add_page.dart';

class AddWidget extends StatefulWidget {
  final Widget child;
  final GZXDropdownMenuController dropdownMenuController;

  const AddWidget(
      {Key key, @required this.dropdownMenuController, @required this.child})
      : super(key: key);

  AddWidgetState createState() => AddWidgetState();
}

class AddWidgetState extends State<AddWidget> {
  @override
  Widget build(BuildContext context) {
    ScreenScaler scaler = new ScreenScaler()..init(context);

//    final _auth = Provider.of<AuthModel>(context, listen: true);
    return Stack(children: <Widget>[
      Column(
        children: <Widget>[
          Expanded(
            child: widget.child,
          ),
        ],
      ),
      GZXDropDownMenu(
          dropdownMenuChanged: (isCompleted, currentMenuIndex) {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          // controller用于控制menu的显示或隐藏
          controller: widget.dropdownMenuController,
          // 下拉菜单显示或隐藏动画时长
          animationMilliseconds: 300,
          // 下拉后遮罩颜色
//          maskColor: Theme.of(context).primaryColor.withOpacity(0.5),
//          maskColor: Colors.red.withOpacity(0.5),
          // 下拉菜单，高度自定义，你想显示什么就显示什么，完全由你决定，你只需要在选择后调用_dropdownMenuController.hide();即可
          menus: [
            GZXDropdownMenuBuilder(
              dropDownHeight: scaler.getHeight(48),
//              dropDownWidget: Container(
//                width: scaler.getWidth(100),
//                height: scaler.getHeight(30),
//                color: Colors.blue,
//                child: Text('hhd'),
//              ),
              dropDownWidget: TabBarTabPage(),
            ),
          ]),
    ]);
  }
}
