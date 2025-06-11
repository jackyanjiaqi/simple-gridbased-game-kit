// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils.dart';
import 'events.dart';

const KEY_LEFT = '←';
const KEY_DOWN = '↓';
const KEY_UP = '↑';
const KEY_RIGHT = '→';
const KEY_A = 'A';
const KEY_S = 'S';
const KEY_W = 'W';
const KEY_D = 'D';
const KEY_J = 'J';
const KEY_K = 'K';
const KEY_L = 'L';
const KEY_I = 'I';
const KEY_Q = 'Q';
const KEY_E = 'E';
const KEY_U = 'U';
const KEY_O = 'O';
const KEY_4 = '4';
const KEY_5 = '5';
const KEY_6 = '6';
const KEY_7 = '7';
const KEY_8 = '8';
const KEY_9 = '9';

const KEYBOARD_AWSD = 'AWSD';
const KEYBOARD_JIKL = 'JIKL';
const KEYBOARD_ARROW = 'ARROW';
const KEYBOARD_NUMPAD = 'NUMPAD';
const GAMEPAD_IINE_NUMPAD = 'IINE_NUM';


typedef EnableBindPadID = (bool, int);
class KeyboardActionsController extends TextEditingController {
  
}

class KeyboardActionsLisenter extends StatelessWidget {
  final Widget child;
  final void Function(PadActionEvent, String)? onPadEvent;
  final TextEditingController controller;
  final FocusNode? keyboardFocus;
  final FocusNode? textfieldFocus;
  final PadActionDispatcher? dispatcher;
  final EnableBindPadID setAWSD;
  final EnableBindPadID setArrows;
  final EnableBindPadID setNumpad;
  final EnableBindPadID setIINEArrow;
  final EnableBindPadID setJIKL;
  final List<Widget>? floatings;
  final KeyEventTransfer? keyEventTransfer;
  const KeyboardActionsLisenter({
    required this.child, 
    required this.controller,
    this.keyEventTransfer,
    this.floatings,
    this.keyboardFocus,
    this.textfieldFocus,
    this.dispatcher,
    this.onPadEvent, 
    this.setAWSD = (true, 1),
    this.setArrows = (true, 2),
    this.setNumpad = (true, 3),
    this.setIINEArrow = (true, 1),
    this.setJIKL = (true, 4)
    });

  void dispatchCall(PadActionEvent event, int playerID){
    dispatcher?.dispatch(event, playerID);
    onPadEvent?.call(event, playerID.toString());
  }
  
  void textDispatchCall(PadActionEvent event, int playerID){
    dispatcher?.dispatch(event, playerID);
    onPadEvent?.call(event,  'text:$playerID');
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardListener(
      focusNode: keyboardFocus ?? FocusNode(), 
      autofocus: true,
      onKeyEvent: (KeyEvent event){
        keyEventTransfer?.transferKeyEvent(event);
        //// Down (Repeat Repeat ...)长按 Up
        if(event.runtimeType == KeyDownEvent) return;
        gridbasedDebug('keyboard:$event');
        switch(event.logicalKey){
          case LogicalKeyboardKey.keyA:
            if(setAWSD.$1){
              dispatchCall(PadActionEvent.left, setAWSD.$2);
              break;
            }
          case LogicalKeyboardKey.arrowLeft:
            if(setArrows.$1){
              dispatchCall(PadActionEvent.left, setArrows.$2);
              break;
            }
          case LogicalKeyboardKey.digit4:
            if(setIINEArrow.$1){
              dispatchCall(PadActionEvent.left, setIINEArrow.$2);
              break;
            }
          case LogicalKeyboardKey.numpad4:
            if(setNumpad.$1){
              dispatchCall(PadActionEvent.left, setNumpad.$2);
              break;
            }
          case LogicalKeyboardKey.keyJ:
            if(setJIKL.$1){
              dispatchCall(PadActionEvent.left, setJIKL.$2);
              break;
            }
          case LogicalKeyboardKey.keyD:
            if(setAWSD.$1){
              dispatchCall(PadActionEvent.right, setAWSD.$2);
              break;
            }
          case LogicalKeyboardKey.arrowRight:
            if(setArrows.$1){
              dispatchCall(PadActionEvent.right, setArrows.$2);
              break;
            }
          case LogicalKeyboardKey.digit2:
            if(setIINEArrow.$1){
              dispatchCall(PadActionEvent.right, setIINEArrow.$2);
              break;
            }
          case LogicalKeyboardKey.numpad6:
            if(setNumpad.$1){
              dispatchCall(PadActionEvent.right, setNumpad.$2);
              break;
            }
          case LogicalKeyboardKey.keyL:
            if(setJIKL.$1){
              dispatchCall(PadActionEvent.right, setJIKL.$2);
              break;
            }
          case LogicalKeyboardKey.keyW:
            if(setAWSD.$1){
              dispatchCall(PadActionEvent.up, setAWSD.$2);
              break;
            }
          case LogicalKeyboardKey.arrowUp:
            if(setArrows.$1){
              dispatchCall(PadActionEvent.up, setArrows.$2);
              break;
            }
          case LogicalKeyboardKey.digit1:
            if(setIINEArrow.$1){
              dispatchCall(PadActionEvent.up, setIINEArrow.$2);
              break;
            }
          case LogicalKeyboardKey.numpad8:
            if(setNumpad.$1){
              dispatchCall(PadActionEvent.up, setNumpad.$2);
              break;
            }
          case LogicalKeyboardKey.keyI:
            if(setJIKL.$1){
              dispatchCall(PadActionEvent.up, setJIKL.$2);
              break;
            }
          case LogicalKeyboardKey.keyS:
            if(setAWSD.$1){
              dispatchCall(PadActionEvent.down, setAWSD.$2);
              break;
            }
          case LogicalKeyboardKey.arrowDown:
            if(setArrows.$1){
              dispatchCall(PadActionEvent.down, setArrows.$2);
              break;
            }
          case LogicalKeyboardKey.digit3:
            if(setIINEArrow.$1){
              dispatchCall(PadActionEvent.down, setIINEArrow.$2);
              break;
            } 
          case LogicalKeyboardKey.numpad5:
            if(setNumpad.$1){
              dispatchCall(PadActionEvent.down, setNumpad.$2);
              break;
            }
          case LogicalKeyboardKey.keyK:
            if(setJIKL.$1){
              dispatchCall(PadActionEvent.down, setJIKL.$2);
              break;
            }
          case LogicalKeyboardKey.keyQ:
            if(setAWSD.$1){
              dispatchCall(PadActionEvent.prevLeft, setAWSD.$2);
              break;
            }
          case LogicalKeyboardKey.numpad7:
            if(setNumpad.$1){
              dispatchCall(PadActionEvent.prevLeft, setNumpad.$2);
              break;
            }
          case LogicalKeyboardKey.keyU:
            if(setJIKL.$1){
              dispatchCall(PadActionEvent.prevLeft, setJIKL.$2);
              break;
            }
          case LogicalKeyboardKey.keyE:
            if(setAWSD.$1){
              dispatchCall(PadActionEvent.nextRight, setAWSD.$2);
              break;
            }
          case LogicalKeyboardKey.numpad9:
            if(setNumpad.$1){
              dispatchCall(PadActionEvent.nextRight, setNumpad.$2);
              break;
            } 
          case LogicalKeyboardKey.keyO:
            if(setJIKL.$1){
              dispatchCall(PadActionEvent.nextRight, setJIKL.$2);
              break;
            }
          case LogicalKeyboardKey.space:
            onPadEvent?.call(PadActionEvent.raw, '${event.logicalKey.keyId}:Space');
            break;
          default:
            onPadEvent?.call(PadActionEvent.raw, '${event.logicalKey.keyId}:${event.logicalKey.keyLabel}');
        }
      }, child: textFieldWrap(child),);
  }

  textFieldWrap(Widget child){
    return Stack(children: [
      Opacity(
        opacity: 0.0, // 完全透明
        child: IgnorePointer(
          ignoring: false, // 仍然允许接收键盘输入
          child: TextField(
            focusNode: textfieldFocus,
            controller: controller,
            onChanged: (String text){
                switch(text){
                  //// ASDW
                  case 'a':
                  case 'A':
                    if(setAWSD.$1){
                      textDispatchCall(PadActionEvent.left, setAWSD.$2);
                      break;
                    }
                  case 's':
                  case 'S':
                    if(setAWSD.$1){
                      textDispatchCall(PadActionEvent.down, setAWSD.$2);
                      break;
                    }
                  case 'd':
                  case 'D':
                    if(setAWSD.$1){
                      textDispatchCall(PadActionEvent.right, setAWSD.$2);
                      break;
                    }
                  case 'w':
                  case 'W':
                    if(setAWSD.$1){
                      textDispatchCall(PadActionEvent.up, setAWSD.$2);
                      break;
                    }
                  case 'q':
                  case 'Q':
                    if(setAWSD.$1){
                      textDispatchCall(PadActionEvent.prevLeft, setAWSD.$2);
                      break;
                    }
                  case 'e':
                  case 'E':
                    if(setAWSD.$1){
                      textDispatchCall(PadActionEvent.nextRight, setAWSD.$2);
                      break;
                    }
                  /// JKLI
                  case 'j':
                  case 'J':
                    if(setJIKL.$1){
                      textDispatchCall(PadActionEvent.left, setJIKL.$2);
                      break;
                    }
                  case 'k':
                  case 'K':
                    if(setJIKL.$1){
                      textDispatchCall(PadActionEvent.down, setJIKL.$2);
                      break;
                    }
                  case 'l':
                  case 'L':
                    if(setJIKL.$1){
                      textDispatchCall(PadActionEvent.right, setJIKL.$2);
                      break;
                    }
                  case 'i':
                  case 'I':
                    if(setJIKL.$1){
                      textDispatchCall(PadActionEvent.up, setJIKL.$2);
                      break;
                    }
                  case 'u':
                  case 'U':
                    if(setJIKL.$1){
                      textDispatchCall(PadActionEvent.prevLeft, setJIKL.$2);
                      break;
                    }
                  case 'o':
                  case 'O':
                    if(setJIKL.$1){
                      textDispatchCall(PadActionEvent.nextRight, setJIKL.$2);
                      break;
                    }
                  default:
                    onPadEvent?.call(PadActionEvent.raw, 'text:$text');
                }
                controller.text = '';
              },))),
      child,
      ...floatings ?? []
    ]);
  }
}