// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ketchup_ui/nav/page_builder.dart';
import 'package:ketchup_ui/ketchup_ui.dart';

typedef MatrixRectGetter = RectGetter Function(int xIndex, int yIndex, {int? toXIndex, int? toYIndex, String? named, List<String> extras, Size? sampleSortSize});

abstract class GridContextNavPageBuilder<T extends GridContext> extends NavPageWidget{

  int? _previousColumns;
  int? _currentColumns;
  void Function(VoidCallback, [String? debug]) get update;

  @override
  void onMeasured(ScreenContext screen) {
    update(()=>updateGridContext(screen.measuredPT(willChangePT.$1)), 'onMeasured-updateGridContext');
    if(!screen.containsSizeChangeListener(gridTag)){
      screen.addRatioChangeListener((Size size, __, ___){
        WidgetsBinding.instance.addPostFrameCallback((_){
          update(()=>updateGridContext(screen.measuredPT(willChangePT.$1)), 'ScreenRe$size-updateGridContext');
        });
      }, tag: gridTag);
    }
  }

  int? get columns => _currentColumns;

  int? get prevColumns => _previousColumns;

  set columns(int? column){
    _previousColumns = _currentColumns;
    _currentColumns = column;  
  }

  late ScreenPT willChangePT;

  GridContextNavPageBuilder();

  @override
  void onScreenWillChange(ScreenPT willChangePT) {
    this.willChangePT = willChangePT;
    columns = ScreenContext.columnPosFromScreenPT(willChangePT.$1)?.$3;
  }

  @override
  void onStateInit(void Function(VoidCallback c, [String? d]) stateUpdater) {
  }

  @override
  List<Widget>? screenBuild(BuildContext context, ContextAccessor ctxAccessor, ScreenPT screenPT) {
    var measured = ctxAccessor.screen.measuredPT(screenPT.$1);
    return measured != null && isGridContextCreated ? createFromMatrix(matrixRectGetter, measured)(context, ctxAccessor, screenPT) : [Text('measureing...')];
  }
  
  String get gridTag;
  T updateGridContext([Rect? measured]);
  bool get matrixReverseX;
  bool get matrixReverseY;
  
  /// 子类需要实现
  WidgetsBuilder createFromMatrix(MatrixRectGetter getRect, Rect measured);

  bool get isGridContextCreated;
  
  /// 根据网格线语境获得网格矩阵
  List<List<RectGetter>> get matrix => namedMatrix(reverseX: matrixReverseX, reverseY: matrixReverseY, named: gridTag);

  List<List<RectGetter>> namedMatrix({bool reverseX = false, bool reverseY = false,required String named, List<String> extras= const [], Size? sampleSortSize}){
    return updateGridContext().createRectGetterMatrix(reverseX: reverseX, reverseY: reverseY, includes: [ ...extras, named, ], sampleSortSize: sampleSortSize);
  }

  /// 进行逻辑坐标系到矩阵坐标系转换
  RectGetter matrixRectGetter(int xIndex, int yIndex, {int? toXIndex, int? toYIndex, String? named, List<String> extras = const [], Size? sampleSortSize}){
    // gameDebug('matrixRectGetter:x:$xIndex,y:$yIndex,toX:$toXIndex,toY:$toYIndex');
    if(toXIndex != null || toYIndex != null){
      return (Size size)=>matrixRectGetter(xIndex, yIndex, named: named, extras: extras, sampleSortSize: sampleSortSize)(size).expandToInclude(
        matrixRectGetter(toXIndex ?? xIndex, toYIndex ?? yIndex, named: named, extras: extras, sampleSortSize: sampleSortSize)(size));
    }
    return (named != null ? namedMatrix(named: named, extras: extras, sampleSortSize: sampleSortSize) : matrix)[yIndex][xIndex];
  }
}