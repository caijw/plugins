import 'dart:async';

import 'package:flutter/services.dart';

import 'dart:async';
import 'dart:ffi';
import 'dart:io' show Platform;
import 'package:ffi/ffi.dart';


// char *echoBigString(char *str);
typedef _echoBigString_func = Pointer<Utf8> Function(Pointer<Utf8> title);
typedef _echoBigString = Pointer<Utf8> Function(Pointer<Utf8> title);

final String _dylibPath = '/home/jingweicai/Documents/code/plugins/plugin1/ffi/libffi.so';
final DynamicLibrary _dylib = DynamicLibrary.open(_dylibPath);

final _echoBigStringV2 = _dylib.lookup<NativeFunction<_echoBigString_func>>('echoBigString').asFunction<_echoBigString>();

class Plugin1 {
  static const MethodChannel _channel =
      const MethodChannel('plugin1');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<String>  echoBigString(String str) async {
    final String receiveStr = await _channel.invokeMethod('echoBigString', str);
    return receiveStr;
  }
  static Future<String>  echoBigStringV2(String str) async {
    final String receiveStr = Utf8.fromUtf8( _echoBigStringV2(Utf8.toUtf8(str)) );
    return receiveStr;
  }
}
