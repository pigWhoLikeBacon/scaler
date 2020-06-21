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


## 服务器

此项目服务器为scaler_web,项目地址：https://github.com/pigWhoLikeBacon/scaler_web


## 与服务器交互

服务器返回401，403等状态异常码时，过滤器自动截获并直接在app上显示服务器返回的错误信息。

服务器返回200，过滤器不做任何操作，由其他代码部分识别，为200时，进行自定义操作。


## 推送功能

flutter 目前还没有比较完整的适用于中国的推送插件，

待各个插件完善后再添加此项功能
