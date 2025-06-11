// ignore_for_file: constant_identifier_names

import 'dart:ui';
import '../utils.dart';

typedef GridPos = ({int x,int y});
const GridZero = (x: 0, y: 0);
const GridXStep = (x: 1, y: 0);
const GridYStep = (x: 0, y: 1);
const GridXYStep = (x: 1, y: 1);
const GridXDouble = (x: 2, y: 0);
const GridXDoubleYStep = (x: 2, y: 1);
const GridYDouble = (x: 0, y: 2);
const GridXStepYDouble = (x: 1, y: 2);
const GridXYDouble = (x: 2, y: 2);
const GridXTriple = (x: 3, y: 0);
const GridYTriple = (x: 0, y: 3);


GridPos addUpGridPos(GridPos gp1, GridPos gp2){
  return (x: gp1.x + gp2.x, y: gp1.y + gp2.y);  
}

/// 单元格信息
class GridUnit{
    final GridPos Function(GridPos axis) posGetter;// 自身坐标系,依赖中心点计算
    final Paint? decorate;// 方格颜色
    final GridPos offsetPos;// 加入 group 后会有 parentPos
    const GridUnit({required this.posGetter, this.offsetPos = GridZero, this.decorate});
    factory GridUnit.offset({required GridPos offset, Paint? decorate})=>GridUnit(posGetter: (GridPos axis)=>(x: axis.x + offset.x, y: axis.y + offset.y ), offsetPos: offset, decorate: decorate);
    /// 该工厂方法将 parentPos 设置成 offset 后的偏移后的坐标值，不改变原始 pos 自身坐标系
    /// 有利于 以 group方式 添加到 parent group 之后保留原来 group 的原始坐标信息
    /// 同一个 Unit 最多存在两个 Group 中，父亲和当前 Group 否则会丢失信息
    factory GridUnit.axisExchange(GridUnit copied, 
      GridPos changeBefore, GridPos changeAfter)=>GridUnit.offset(offset: (x: copied.offsetPos.x + changeBefore.x - changeAfter.x, y: copied.offsetPos.y + changeBefore.y - changeAfter.y));
         
    GridUnit changeAxis(GridPos axisBefore, GridPos axisAfter){
      return GridUnit.axisExchange(this, axisBefore, axisAfter);
    }

    GridUnit offset(GridPos offset){
      return GridUnit.offset(offset: (x: offsetPos.x + offset.x, y: offsetPos.y + offset.y), decorate: decorate);
    }
    // bool addToGroup({required LogicCubeGroup group, 
    //             required GridPos offset,required bool allowDuplicate}){
    //   return group._addUnit(CubeUnit.offset(this, offset), allowDuplicate: allowDuplicate);
    // }

    // bool testInGroup({required LogicCubeGroup group, 
    //             required GridPos offset}){
    //   return group.isNotBlank((x: offset.x + posGetter.x, y: offset.y + posGetter.y));
    // }
  
}

/// 逻辑方块组
class LogicGridGroup{
  final String? name;
  final List<GridUnit> data;
  final GridPos axis;
  const LogicGridGroup({ required this.data, required this.axis, this.name });
  factory LogicGridGroup.map({required GridUnit Function(GridUnit) map, required LogicGridGroup group})=> LogicGridGroup(data: group.data.map<GridUnit>(map).toList(), axis: group.axis);
  factory LogicGridGroup.updateAxis({required GridPos axis,required LogicGridGroup copied, String? name}) => LogicGridGroup(data: copied.data, axis: axis, name: name ?? copied.name);
  factory LogicGridGroup.empty({GridPos fromStartAxis = GridZero, String? name})=>
    LogicGridGroup(axis: fromStartAxis, name: name,
      data: []);
  factory LogicGridGroup.dice2x2Group({GridPos fromStartAxis = GridZero, String? name})=>
    LogicGridGroup(axis: fromStartAxis, name: name, data: [
      GridUnit.offset(offset: GridZero),
      GridUnit.offset(offset: GridXStep), 
      GridUnit.offset(offset: GridYStep), 
      GridUnit.offset(offset: GridXYStep), 
  ]);
  factory LogicGridGroup.wide1x4Group({GridPos fromStartAxis = GridZero, String? name})=>
    LogicGridGroup(axis: fromStartAxis, name: name, data: [
      GridUnit.offset(offset: GridZero),
      GridUnit.offset(offset: GridXStep), 
      GridUnit.offset(offset: GridXDouble), 
      GridUnit.offset(offset: GridXTriple), 
  ]);
  factory LogicGridGroup.high4x1Group({GridPos fromStartAxis = GridZero, String? name})=>
    LogicGridGroup(axis: fromStartAxis, name: name, data: [
      GridUnit.offset(offset: GridZero),
      GridUnit.offset(offset: GridYStep), 
      GridUnit.offset(offset: GridYDouble), 
      GridUnit.offset(offset: GridYTriple), 
  ]);
  factory LogicGridGroup.leftTopWideLGroup({GridPos fromStartAxis = GridZero, String? name})=>
   LogicGridGroup(axis: fromStartAxis, name: name, data: [
      GridUnit.offset(offset: GridZero),
      GridUnit.offset(offset: GridYStep), 
      GridUnit.offset(offset: GridXStep), 
      GridUnit.offset(offset: GridXDouble), 
  ]);
  factory LogicGridGroup.rightTopWideLGroup({GridPos fromStartAxis = GridZero, String? name})=>
   LogicGridGroup(axis: fromStartAxis, name: name, data: [
      GridUnit.offset(offset: GridZero),
      GridUnit.offset(offset: GridXStep),
      GridUnit.offset(offset: GridXDouble),
      GridUnit.offset(offset: GridXDoubleYStep),
  ]);
  factory LogicGridGroup.leftBottomWideLGroup({GridPos fromStartAxis = GridZero, String? name})=>
   LogicGridGroup(axis: fromStartAxis, name: name, data: [
      GridUnit.offset(offset: GridZero),
      GridUnit.offset(offset: GridYStep),
      GridUnit.offset(offset: GridXYStep),
      GridUnit.offset(offset: GridXDoubleYStep),
  ]);
  factory LogicGridGroup.rightBottomWideLGroup({GridPos fromStartAxis = GridZero, String? name})=>
   LogicGridGroup(axis: fromStartAxis, name: name, data: [
      GridUnit.offset(offset: GridYStep),
      GridUnit.offset(offset: GridXYStep),
      GridUnit.offset(offset: GridXDoubleYStep),
      GridUnit.offset(offset: GridXDouble),
  ]);
  factory LogicGridGroup.leftTopHighLGroup({GridPos fromStartAxis = GridZero, String? name})=>
   LogicGridGroup(axis: fromStartAxis, name: name, data: [
      GridUnit.offset(offset: GridZero),
      GridUnit.offset(offset: GridXStep),
      GridUnit.offset(offset: GridYStep),
      GridUnit.offset(offset: GridYDouble),
  ]);
  factory LogicGridGroup.rightTopHighLGroup({GridPos fromStartAxis = GridZero, String? name})=>
   LogicGridGroup(axis: fromStartAxis, name: name, data: [
      GridUnit.offset(offset: GridZero),
      GridUnit.offset(offset: GridXStep),
      GridUnit.offset(offset: GridXYStep),
      GridUnit.offset(offset: GridXStepYDouble),
  ]);
  factory LogicGridGroup.leftBottomHighLGroup({GridPos fromStartAxis = GridZero, String? name})=>
   LogicGridGroup(axis: fromStartAxis, name: name, data: [
      GridUnit.offset(offset: GridZero),
      GridUnit.offset(offset: GridYStep),
      GridUnit.offset(offset: GridYDouble),
      GridUnit.offset(offset: GridXStepYDouble),
  ]);
  factory LogicGridGroup.rightBottomHighLGroup({GridPos fromStartAxis = GridZero, String? name})=>
   LogicGridGroup(axis: fromStartAxis, name: name, data: [
      GridUnit.offset(offset: GridXStep),
      GridUnit.offset(offset: GridXYStep),
      GridUnit.offset(offset: GridYDouble),
      GridUnit.offset(offset: GridXStepYDouble),
  ]);
  factory LogicGridGroup.leftRaiseGroup({GridPos fromStartAxis = GridZero, String? name})=>
   LogicGridGroup(axis: fromStartAxis, name: name, data: [
      GridUnit.offset(offset: GridYStep),
      GridUnit.offset(offset: GridXStep),
      GridUnit.offset(offset: GridXYStep),
      GridUnit.offset(offset: GridXStepYDouble),
  ]);
  factory LogicGridGroup.rightRaiseGroup({GridPos fromStartAxis = GridZero, String? name})=>
   LogicGridGroup(axis: fromStartAxis, name: name, data: [
      GridUnit.offset(offset: GridZero),
      GridUnit.offset(offset: GridYStep),
      GridUnit.offset(offset: GridXYStep),
      GridUnit.offset(offset: GridYDouble),
  ]);
  factory LogicGridGroup.topRaiseGroup({GridPos fromStartAxis = GridZero, String? name})=>
   LogicGridGroup(axis: fromStartAxis, name: name, data: [
      GridUnit.offset(offset: GridXStep),
      GridUnit.offset(offset: GridYStep),
      GridUnit.offset(offset: GridXYStep),
      GridUnit.offset(offset: GridXDoubleYStep),
  ]);
  factory LogicGridGroup.bottomRaiseGroup({GridPos fromStartAxis = GridZero, String? name})=>
   LogicGridGroup(axis: fromStartAxis, name: name, data: [
      GridUnit.offset(offset: GridZero),
      GridUnit.offset(offset: GridXStep),
      GridUnit.offset(offset: GridXDouble),
      GridUnit.offset(offset: GridXYStep),
  ]);
  factory LogicGridGroup.positiveZGroup({GridPos fromStartAxis = GridZero, String? name})=>
   LogicGridGroup(axis: fromStartAxis, name: name, data: [
      GridUnit.offset(offset: GridZero),
      GridUnit.offset(offset: GridXStep),
      GridUnit.offset(offset: GridXYStep),
      GridUnit.offset(offset: GridXDoubleYStep),
  ]);
  factory LogicGridGroup.reverseZGroup({GridPos fromStartAxis = GridZero, String? name})=>
   LogicGridGroup(axis: fromStartAxis, name: name, data: [
      GridUnit.offset(offset: GridXDouble),
      GridUnit.offset(offset: GridXStep),
      GridUnit.offset(offset: GridXYStep),
      GridUnit.offset(offset: GridYStep),
  ]);
  factory LogicGridGroup.positiveNGroup({GridPos fromStartAxis = GridZero, String? name})=>
   LogicGridGroup(axis: fromStartAxis, name: name, data: [
      GridUnit.offset(offset: GridXStep),
      GridUnit.offset(offset: GridYStep),
      GridUnit.offset(offset: GridXYStep),
      GridUnit.offset(offset: GridYDouble),
  ]);
  factory LogicGridGroup.reverseNGroup({GridPos fromStartAxis = GridZero, String? name})=>
   LogicGridGroup(axis: fromStartAxis, name: name, data: [
      GridUnit.offset(offset: GridZero),
      GridUnit.offset(offset: GridYStep),
      GridUnit.offset(offset: GridXYStep),
      GridUnit.offset(offset: GridXStepYDouble),
  ]);

  LogicGridGroup updateAxis(GridPos axis){
    return LogicGridGroup.updateAxis(axis: axis, copied: this);
  }
  
  LogicGridGroup updateAxisVector(GridPos vector){
    return LogicGridGroup.updateAxis(axis: addUpGridPos(axis, vector), copied: this);
  }

  List<GridUnit> units(GridPos pos){
    return data.where((cu)=>cu.posGetter(axis) == pos).toList();
  }
  
  bool isBlank(GridPos pos){
    return units(pos).isEmpty;
  }

  bool isNotBlank(GridPos pos){
    return units(pos).isNotEmpty;
  }
  
  // bool _addUnit(CubeUnit unit, {bool allowDuplicate = false}){
  //   if(unit.parentPos != null && (allowDuplicate || isBlank(unit.parentPos!))){
  //     data.add(unit);
  //     return true;
  //   }
  //   return false;
  // }
  
  /// 返回值只表示是否全部添加成功, partial时有可能添加部分且整体返回 false
  // bool add(LogicCubeGroup group, {GridPos offset = GridZero, bool allowDuplicate = false, bool partial = true}){
  //   if(partial || !group.data.any((cube)=>cube.testInGroup(group: this, offset: offset))){
  //     return group.data.every((cube)=>cube.addToGroup(group: this, offset: offset, allowDuplicate: allowDuplicate));
  //   }
  //   return false;
  // }

  GridPos size(){
    int maxX = 0;
    int maxY = 0;
    for (var unit in data) {
      var current = unit.posGetter(GridZero); 
      if(current.x > maxX) maxX = current.x;
      if(current.y > maxY) maxY = current.y;
    }
    return (x: maxX, y: maxY);
  }

  int testRemoveLines({int? width}){
    if(data.isEmpty) return -1;
    for(var y = 0; y<= size().y; y++){
      if(List.generate(width ?? size().x + 1, (x)=>(x: x, y: y)).every((pos)=>isNotBlank(pos))){
        return y;
      }
    }
    return -1;
  }

  void removeLine(int y){
    data.removeWhere((unit)=>unit.posGetter(axis).y == y);
    var remains = data.map<GridUnit>((unit){
      if(unit.posGetter(axis).y < y){
        return unit.offset(GridYStep);
      } else {
        return unit;
      }
    }).toList();
    data.clear();
    data.addAll(remains);
  }  

  bool testBeyondBoundry(GridPos pos,int rowMax, int columnMax){
    gridbasedDebug('testBeyondBoundry:$pos,$rowMax,$columnMax');
    // return (pos.x < 0 || pos.y < 0 || pos.x >= columnMax || pos.y >= rowMax);
    return (pos.x < 0 || pos.x >= columnMax || pos.y >= rowMax);
  }

  bool testCollision(LogicGridGroup falling, {required GridPos dVector, required int rowMax, required int columnMax }){
    return falling.data.any((unit){
      var tester = (x: unit.posGetter(falling.axis).x + dVector.x, y: unit.posGetter(falling.axis).y + dVector.y);
      return testBeyondBoundry(tester, rowMax, columnMax) || isNotBlank(tester);
    });
  }

  merge(LogicGridGroup group){
    data.addAll(group.data.map((unit)=>unit.changeAxis(group.axis, axis)));
  }
  
}