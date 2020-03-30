import 'dart:async';
import 'package:flutter/services.dart';
import 'dart:ffi' as ffi;
import 'dart:io' show Platform;

// FFI signature of the hello_world C function
typedef hello_world_func = ffi.Void Function();
// Dart type definition for calling the C foreign function
typedef HelloWorld = void Function();


class Binder {
  static ffi.DynamicLibrary _dylib;
  static const MethodChannel _channel =
      const MethodChannel('binder');

  static Future<String> get platformVersion async {
    if (_dylib == null) {
      var path = "../hello_library/libhello.so";
      if (Platform.isMacOS) path = '../hello_library/libhello.dylib';
      _dylib = ffi.DynamicLibrary.open(path);
    }
    // Look up the C function 'hello_world'
    final HelloWorld hello = _dylib
        .lookup<ffi.NativeFunction<hello_world_func>>('hello_world')
        .asFunction();
    hello();
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
