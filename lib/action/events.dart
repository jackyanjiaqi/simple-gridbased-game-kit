/// 游戏接收的输入事件
enum GameActionEvent {
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

abstract class GameActionsAcceptor{
  void accept(GameActionEvent gameEvent, PadActionEvent padEvent, int padID);
}

abstract class PadActionConsumer{
  void accept(PadActionEvent padEvent, String extra);
}

abstract class ScreenActionsConsumer extends GameActionsAcceptor{
  int get mainPadID;
  late List<int> padIDs;
  void focus(int padID);
  void unfocus(int padID);
}

abstract class PadActionDispatcher{
  void dispatch(PadActionEvent event, int padID);
}


abstract class ScreenActionsAcceptor{
  void screenLeft(int padID);
  void screenRight(int padID);
}

mixin ActionsAccessor{
  List<GameActionsAcceptor> get gameActions;
  ScreenActionsAcceptor get screenActions;
}