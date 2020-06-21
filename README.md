# scaler

A new Flutter application.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.


## 介绍

这是一个简单的，用于记录事件，日志，日常任务及其完成情况的app。

这是博主的练手项目，市场上有很多类似的app。


## 图片

![image](https://github.com/pigWhoLikeBacon/scaler/blob/master/images/Screenshot_2020-06-21-13-40-34-173_com.example.sc.png)
![image](https://github.com/pigWhoLikeBacon/scaler/blob/master/images/Screenshot_2020-06-21-13-40-34-173_com.example.sc.png)
![image](https://github.com/pigWhoLikeBacon/scaler/blob/master/images/Screenshot_2020-06-21-13-40-34-173_com.example.sc.png)
![image](https://github.com/pigWhoLikeBacon/scaler/blob/master/images/Screenshot_2020-06-21-13-40-34-173_com.example.sc.png)
![image](https://github.com/pigWhoLikeBacon/scaler/blob/master/images/Screenshot_2020-06-21-13-40-34-173_com.example.sc.png)


## 服务器

此项目服务器为scaler_web,项目地址：https://github.com/pigWhoLikeBacon/scaler_web


## 与服务器交互

服务器返回401，403等状态异常码时，过滤器自动截获并直接在app上显示服务器返回的错误信息。

服务器返回200，过滤器不做任何操作，由其他代码部分识别，为200时，进行自定义操作。


## 推送功能

flutter 目前还没有比较完整的适用于中国的推送插件，

待各个插件完善后再添加此项功能。


## 文件功能介绍

lib  
├─back   操作客户端底层数据  
│ ├─database  
│ │ ├─db.dart   存放sqflite实例  
│ │ └─sp.dart   存放shared_preferences实例  
│ ├─entity   存放实体类  
│ │ ├─base.dart  
│ │ ├─day.dart  
│ │ ├─day.g.dart  
│ │ ├─day_plan.dart  
│ │ ├─day_plan.g.dart  
│ │ ├─event.dart  
│ │ ├─event.g.dart  
│ │ ├─plan.dart  
│ │ └─plan.g.dart  
│ └─service   伪服务层，存放部分服务  
│   ├─aync_service.dart  
│   ├─day_plan_service.dart  
│   ├─day_service.dart  
│   ├─event_service.dart  
│   └─plan_service.dart  
├─global  
│ ├─config.dart   存放cookie，username以及各种设置  
│ ├─global.dart   使用provider插件，存放全局变量  
│ └─theme_data.dart   存放当前使用的theme以及全部的theme  
├─main.dart  
├─page   存放各种页面  
│ ├─calendar_page  
│ │ ├─calendar_event.dart  
│ │ ├─calendar_page.dart  
│ │ ├─calendar_plan.dart  
│ │ └─edit_log_page.dart  
│ ├─login_page.dart  
│ ├─plan_page.dart  
│ └─settings_page.dart  
├─tab_navigator.dart   底部导航栏  
├─util  
│ ├─aync_utils.dart   用于于服务器同步数据  
│ ├─background_fetch_utils.dart   目前无用的文件，用于项目未来的拓展性  
│ ├─dialog_utils.dart   弹窗  
│ ├─jpush_utils.dart   目前无用的文件，用于项目未来的拓展性  
│ ├─toast_utils.dart   toast  
│ └─user_utils.dart   提供对于user的一些操作  
├─web   存放项目进行web操作的类  
│ ├─cookie_action.dart   存放对cookie的一些方法  
│ ├─custom_interceptors.dart   requset过滤器  
│ └─http.dart   存放dio的单体实例，会对请求的cookie做出类似于浏览器的操作  
└─widget  
  ├─add   添加event和plan的widget  
  │ ├─add_event_item.dart  
  │ ├─add_page.dart  
  │ ├─add_plan_item.dart  
  │ └─add_widget.dart  
  ├─bar_popup_menu_button.dart   app右上角的widget  
  ├─cached_image.dart   目前无用的文件，用于项目未来的拓展性  
  ├─color_loader_2.dart  
  ├─drawer_widget.dart   左菜单widget  
  ├─restart_widget.dart   用于重启app  
  └─simple_round_button.dart  
