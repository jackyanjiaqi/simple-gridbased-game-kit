import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';


enum TimerstepTriggertype { 
  count, ///刷新次数
  clock, ///定时 
  interval, /// 间隔时间
  all,
  none
}

typedef InnerTimerstepTrigger = ({TimerstepTriggertype type, int count, Duration interval, DateTime start, Duration elapsed});
typedef TimerstepTrigger = ({TimerstepTriggertype type, int count, Duration interval, DateTime start});
typedef TickerStopTrueCallback = bool Function(Duration elapsed);

abstract class AnimTicker{
  void addAnimTicker(TickerStopTrueCallback animTicker);
}

abstract class StepTrigger{
  bool get acceptTrigger;
  void gameStep(InnerTimerstepTrigger stepTrigger);
}

abstract class TimerState<T extends StatefulWidget> extends State<T> with TickerProviderStateMixin implements StepTrigger, AnimTicker{
  late Ticker _timerStateTicker;
  late InnerTimerstepTrigger _timerStateCounter;
  final List<TickerStopTrueCallback> _timerStateAnimTickers = [];
  void startGameloop(TimerstepTrigger condition){
    _timerStateCounter = (type: condition.type, count: 0, interval: Duration.zero, elapsed: Duration.zero, start: DateTime.now());
    _timerStateTicker = createTicker((Duration elapsed){
      // gameDebug('ticker-elapsed:$elapsed');
      if(acceptTrigger){
        if(_timerStateAnimTickers.isNotEmpty){
          _timerStateAnimTickers.removeWhere((tickerCallback)=>tickerCallback(elapsed - _timerStateCounter.elapsed)); 
        }
        if(_timerStateCounter.type == TimerstepTriggertype.none) return gameStep(_timerStateCounter);
        /// 更新计数
        _timerStateCounter = (type:_timerStateCounter.type, count: _timerStateCounter.count + 1, elapsed: elapsed, interval: _timerStateCounter.interval + elapsed - _timerStateCounter.elapsed, start: _timerStateCounter.start);
        /// 判断
        bool countMatch = _timerStateCounter.count >= condition.count;
        bool intervalMatch = _timerStateCounter.interval >= condition.interval;
        bool nowTimeMatch = DateTime.now().millisecondsSinceEpoch >= condition.start.millisecondsSinceEpoch;
        if(
          _timerStateCounter.type == TimerstepTriggertype.count && countMatch ||
          (_timerStateCounter.type == TimerstepTriggertype.interval && intervalMatch) ||
          (_timerStateCounter.type == TimerstepTriggertype.clock && nowTimeMatch) ||
          (_timerStateCounter.type == TimerstepTriggertype.all && (countMatch || intervalMatch || nowTimeMatch))
          ){
            gameStep(_timerStateCounter);
            _timerStateCounter = (type: condition.type, count: 0, elapsed: elapsed, interval: Duration.zero, start: DateTime.now());
          }else{
            // gameDebug(_elapsed);
          }
      }})
    ..start();
  }
  
  void endGameloop(){
    _timerStateTicker.stop();
  }

  @override
  void addAnimTicker(TickerStopTrueCallback animTicker) {
    _timerStateAnimTickers.add(animTicker);
  }
}