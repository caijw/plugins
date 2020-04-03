import 'dart:async';

import 'package:flutter/services.dart';

class Plugin2 {
  static const MethodChannel _channel =
      // const MethodChannel('WeOS/IPC');
      const MethodChannel('plugin2');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
