import 'dart:async';

import 'package:flutter/services.dart';

import 'dart:async';
import 'dart:ffi';
import 'dart:io' show Platform;
import 'package:ffi/ffi.dart';




typedef BinaryOp = int Function(int, int);
typedef NativeIntptrBinOp = IntPtr Function(IntPtr, IntPtr);
typedef NativeIntptrBinOpLookup = Pointer<NativeFunction<NativeIntptrBinOp>>
    Function();

typedef NativeApplyTo42And74Type = IntPtr Function(
    Pointer<NativeFunction<NativeIntptrBinOp>>);

typedef ApplyTo42And74Type = int Function(
    Pointer<NativeFunction<NativeIntptrBinOp>>);

int myPlus(int a, int b) {
  print("myPlus");
  print(a);
  print(b);
  return a + b;
}

// char *echoBigString(char *str);
typedef _echoBigString_func = Pointer<Utf8> Function(Pointer<Utf8> title);
typedef _echoBigString = Pointer<Utf8> Function(Pointer<Utf8> title);

final String _dylibPath = '/home/jingweicai/Documents/code/plugins/plugin1/ffi/libffi.so';
final DynamicLibrary _dylib = DynamicLibrary.open(_dylibPath);

final _echoBigStringV2 = _dylib.lookup<NativeFunction<_echoBigString_func>>('echoBigString').asFunction<_echoBigString>();

class Plugin1 {
  static const MethodChannel _channel =
      const MethodChannel('plugin1');

  static void initSetMethodCallHandler() {
    if (_initSetMethodCallHandler == true) {
      return;
    }
    _initSetMethodCallHandler = true;
    _channel.setMethodCallHandler(_wrappedCallback);
  }

  static bool _initSetMethodCallHandler = false;

  static Future<String> get platformVersion async {
    initSetMethodCallHandler();
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<String>  echoBigString(String str) async {
    initSetMethodCallHandler();
    final String receiveStr = await _channel.invokeMethod('echoBigString', str);
    return receiveStr;
  }
  static Future<String>  echoBigStringV2(String str) async {
    initSetMethodCallHandler();
    final String receiveStr = Utf8.fromUtf8( _echoBigStringV2(Utf8.toUtf8(str)) );
    return receiveStr;
  }
  static Future<Null> _wrappedCallback(MethodCall methodCall) async {
    // throw '111';
    String args = methodCall.arguments;
    print('receive method call from c++, method: ${methodCall.method}, args: ${args}');
  }
  static ffiRunDartCallbackInC() {

    Pointer<NativeFunction<NativeIntptrBinOp>> pointer =
        Pointer.fromFunction(myPlus, 0); // dart 函数转换为 c 函数指针
    print(pointer);

    Pointer<NativeFunction<NativeApplyTo42And74Type>> p17 =
        _dylib.lookup("ApplyTo42And74");
    ApplyTo42And74Type applyTo42And74 = p17.asFunction();
    int result = applyTo42And74(pointer); // 将 dart 函数传递给 c 函数作为回调
    return result;
  }
}
