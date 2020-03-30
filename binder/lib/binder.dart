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
  static const MethodChannel _channel = const MethodChannel('binder');

  static Future<String> get platformVersion async {
    print('get platformVersion async');
    if (_dylib == null) {
      String os = Platform.operatingSystem;
      String home = "";
      Map<String, String> envVars = Platform.environment;
      if (Platform.isMacOS) {
        home = envVars['HOME'];
      } else if (Platform.isLinux) {
        home = envVars['HOME'];
      } else if (Platform.isWindows) {
        home = envVars['UserProfile'];
      }
      var path = home + "/lib/libbinder_test.so";
      if (Platform.isMacOS) path = home +  '/lib/libbinder_test.dylib';
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
