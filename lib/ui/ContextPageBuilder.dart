import 'dart:ui';
// import 'package:ketchup_ui/ketchup_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:ketchup_ui/ketchup_ui.dart';

abstract class ContextPageBuilder{
  /// 语义化的页面名称，用于 map 存储的 key 键
  String get contextPageName;
  /// 执行的代理方法 build 时执行
  WidgetsBuilder get pageBuilder;
  /// 更新页面调用的方法, 通常是 State.setState; 也可以是 notifyListeners
  void Function(VoidCallback) get update;
  /// 用于过滤屏幕语境
  // bool fillterPT(String? singlePT, String? contextPT);

  /// 子类实现 initState 时执行, 于 build 之前
  void init();
}