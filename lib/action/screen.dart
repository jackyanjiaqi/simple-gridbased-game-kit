import 'events.dart';

abstract mixin class ScreensActionsImpl implements ScreenActionsAcceptor, PadActionDispatcher{

  ScreenActionsConsumer? currentAction(int padID);

  ScreenActionsConsumer? leftAction(int padID);

  ScreenActionsConsumer? rightAction(int padID);

  @override
  void screenLeft(int padID) {
    var current = currentAction(padID);
    var left = leftAction(padID);
    if(left != current){
      current?.unfocus(padID);
      left?.focus(padID);
    }
  }

  @override
  void screenRight(int padID) {
    var current = currentAction(padID);
    var right = rightAction(padID);
    if(right != current){
      current?.unfocus(padID);
      right?.focus(padID);
    }
  }
  
  @override
  void dispatch(PadActionEvent event, int padID) {
    var current = currentAction(padID);
    if(event == PadActionEvent.prevLeft){
      screenLeft(padID);
    }else
    if(event == PadActionEvent.nextRight){
      screenRight(padID);
    }else
    if(current?.mainPadID != padID){
      switch(event){
        case PadActionEvent.left:
          current?.accept(AbstractGameActionEvent.viceLeft, event, padID);
          break;
        case PadActionEvent.right:
          current?.accept(AbstractGameActionEvent.viceRight, event, padID);
          break;
        case PadActionEvent.up:
          current?.accept(AbstractGameActionEvent.viceUp, event, padID);
          break;
        case PadActionEvent.down:
        default:
      }
    }else
    if(current?.mainPadID == padID){
      switch(event){
        case PadActionEvent.left:
          current?.accept(AbstractGameActionEvent.mainLeft, event, padID);
          break;
        case PadActionEvent.right:
          current?.accept(AbstractGameActionEvent.mainRight, event, padID);
          break;
        case PadActionEvent.up:
          current?.accept(AbstractGameActionEvent.mainUp, event, padID);
          break;
        case PadActionEvent.down:
          current?.accept(AbstractGameActionEvent.mainDown, event, padID);
        default:
      }
    }
  }
  
}