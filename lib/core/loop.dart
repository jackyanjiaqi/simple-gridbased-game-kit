enum GameEvent { award, achieve, punish, lost, notify, alert }

abstract class GameEventDispatcher {
  dispatchGameEvent((GameEvent, String, Object) event);
}

abstract class GameLoop {
  
  beforeGameStart();

  /// 开启游戏循环
  gameStart();

  /// 暂停游戏
  gamePause();

  /// 继续游戏
  gameRestart();

  /// 结束游戏
  gameEnd();

  bool get paused;

  bool get ended;
}