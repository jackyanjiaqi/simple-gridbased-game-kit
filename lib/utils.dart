import 'package:flutter/foundation.dart';

T gridbasedDebug<T>(T object, {String? prefix, String? suffix}){
  if(kDebugMode){
    if(prefix != null || suffix != null){
      print('${prefix ?? ''}$object${suffix ?? ''}');
    } else {
      print('gridbasedDebug:$object');
    }
  }
  return object;
}