import 'package:flutter/material.dart';
import 'package:flutter_screen_scaler/flutter_screen_scaler.dart';
import 'package:gzx_dropdown_menu/gzx_dropdown_menu.dart';
import 'package:scaler/page/calendar_page/calendar_page.dart';
import 'package:scaler/page/plan_page.dart';
import 'package:scaler/widget/add/add_widget.dart';

GZXDropdownMenuController dropdownMenuController;

class TabNavigator extends StatefulWidget {
  @override
  _TabNavigatorState createState() => _TabNavigatorState();
}

class _TabNavigatorState extends State<TabNavigator> {
  int _currentIndex = 0;
  List<Widget> _pageList;

  @override
  void initState() {
    dropdownMenuController = GZXDropdownMenuController();
    super.initState();

    _pageList = List();
    _pageList..add(CalendarPage())..add(PlanPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AddWidget(
        child: _pageList[_currentIndex],
        dropdownMenuController: dropdownMenuController,
      ),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(), // 底部导航栏打一个圆形的洞
        child: Row(
          children: <Widget>[
            _bottomItem(Icons.calendar_today, 'Calendar', 0),
            SizedBox(),
            _bottomItem(Icons.announcement, 'Plan', 1),
          ],
          mainAxisAlignment: MainAxisAlignment.spaceAround, //均分底部导航栏横向空间
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        heroTag: 'add',
        onPressed: () {
          if (dropdownMenuController.isShow) {
            dropdownMenuController.hide();
          } else {
            dropdownMenuController.show(0);
          }
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  //底部导航item
  IconButton _bottomItem(IconData icon, String title, int index) {
    return IconButton(
      icon: Icon(
        icon,
      ),
      onPressed: () {
        setState(() {
          _currentIndex = index;
        });
      },
      color: _currentIndex == index
          ? Theme.of(context).accentColor
          : Theme.of(context).unselectedWidgetColor,
    );
  }
}
