import 'package:flutter/material.dart';

/// 实体按键直传
abstract class KeyEventTransfer{
  void transferKeyEvent(KeyEvent kv);
}

/// 游戏接收的逻辑输入事件
enum AbstractGameActionEvent {
  mainLeft,
  mainRight,
  mainUp,
  mainDown,

  viceLeft,
  viceRight,
  viceUp,

  start,
  pause
}

/// 游戏逻辑按键
enum PadActionEvent {
  left, right, up, down,
  prevLeft, nextRight,
  raw
}

/// LogicGame 发出的事件右游戏页面实现游戏逻辑扩展
enum LogicGameEvent { award, achieve, punish, lost, notify, alert }

abstract class LogicGameEventDispatcher {
  dispatchGameEvent((LogicGameEvent, String, Object) event);
}

abstract class AbstractGameActionConsumer{
  void accept(AbstractGameActionEvent gameEvent, PadActionEvent padEvent, int padID);
}

abstract class PadActionConsumer{
  void accept(PadActionEvent padEvent, String extra);
}

abstract class ScreenActionsConsumer extends AbstractGameActionConsumer{
  int get mainPadID;
  late List<int> padIDs;
  void focus(int padID);
  void unfocus(int padID);
}

abstract class PadActionDispatcher{
  void dispatch(PadActionEvent event, int padID);
}

abstract class BypassPadAction {
  bool get bypassPadAction;
}


abstract class ScreenActionsAcceptor{
  void screenLeft(int padID);
  void screenRight(int padID);
}

mixin ActionsAccessor{
  List<AbstractGameActionConsumer> get gameActions;
  ScreenActionsAcceptor get screenActions;
}