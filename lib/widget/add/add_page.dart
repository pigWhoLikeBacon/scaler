import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screen_scaler/flutter_screen_scaler.dart';
import 'package:scaler/config/config.dart';
import 'package:scaler/widget/add/add_plan_item.dart';

import 'add_event_item.dart';


class AddItemBean {
  final String labelTitle;
  final IconData icon;
  final Widget child;

  AddItemBean({this.labelTitle, this.icon, this.child});
}

/**
 * Container 官方给出的简介，是一个结合了绘制（painting）、定位（positioning）以及尺寸（sizing）widget的widget。
 */
class TabBarTabPage extends StatefulWidget {
  TabBarTabPage();

  TabBarTabPageState createState() => TabBarTabPageState();
}

class TabBarTabPageState extends State<TabBarTabPage> {
  @override
  Widget build(BuildContext context) {
    ScreenScaler scaler = new ScreenScaler()..init(context);

    List<AddItemBean> _allPages = <AddItemBean>[
      new AddItemBean(
        labelTitle: "event",
        icon: Icons.info,
        child: AddEventItem(),
      ),
      new AddItemBean(
          labelTitle: "plan",
          icon: Icons.announcement,
          child: Container(
            child: AddPlanItem(),
          )),
    ];

    Widget titleLayout = new TabBar(
      //tabs 的长度超出屏幕宽度后，TabBar，是否可滚动
      //设置为false tab 将平分宽度，为true tab 将会自适应宽度
//      isScrollable: true,
      //每个label的padding值
      labelPadding: EdgeInsets.all(4.0),

      ///指示器大小计算方式，TabBarIndicatorSize.label跟文字等宽,TabBarIndicatorSize.tab跟每个tab等宽
      tabs: _allPages.map((AddItemBean item) {
        return new Tab(
//          child: Center(
//            child: ListTile(
//              leading: Icon(item.icon),
//              title: Text(
//                item.labelTitle,
//                textScaleFactor: Config.get('textScaleFactor'),
//              ),
//            ),
//          ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(item.icon),
            Text('  '),
            Text(item.labelTitle),
          ],
        ),
        );
      }).toList(),
    );
//    new Tab(text: item.labelTitle, icon: Icon(item.icon),)

    Widget body = new TabBarView(
        children: _allPages.map((AddItemBean item) => item.child).toList());

    return new DefaultTabController(
        length: _allPages.length,
        child: new Scaffold(
          appBar: new AppBar(
            //标题是否居中显示，默认值根据不同的操作系统，显示方式不一样,true居中 false居左
            centerTitle: true,
            //Toolbar 中主要内容，通常显示为当前界面的标题文字
            title: titleLayout,
          ),
          body: body,
        ));
  }
}