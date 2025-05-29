import 'dart:ui';

import 'package:flutter/widgets.dart';
import '../utils.dart';
import 'timer.dart';

typedef SafeUpdaterFunc = void Function(VoidCallback, {String? debugInfo, int frames});

mixin DebuggerSafeUpdater{
  String? debugInfo;
  void Function(VoidCallback c, [String? d]) get update;
  void safeUpdate(VoidCallback callback, {String? debugInfo, int frames = 1}){
    if(frames - 1 == 0){
      /// 安全调用 update 并进行 debug 计数
      WidgetsBinding.instance.addPostFrameCallback((Duration dt){
        this.debugInfo = debugInfo;
        update(callback, debugInfo);
      });
    }else{
      WidgetsBinding.instance.addPostFrameCallback((Duration dt){
        safeUpdate(callback, debugInfo: debugInfo, frames: frames - 1);
      });
    }
  }
}

mixin DebuggerStateSafeUpdater on TimerState{

  String? _debugInfo;
  
  @override
  Widget build(BuildContext context) {
    gridbasedDebug(_debugInfo);
    return super.build(context);
  }

  void safeUpdate(VoidCallback callback, [String? debugInfo]){
    /// 安全调用 update 并进行 debug 计数
    WidgetsBinding.instance.addPostFrameCallback((Duration dt){
      _debugInfo = debugInfo;
      setState(callback);
    });
  }
}