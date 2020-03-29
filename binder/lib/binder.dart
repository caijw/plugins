import 'dart:async';

import 'package:flutter/services.dart';

class Binder {
  static const MethodChannel _channel =
      const MethodChannel('binder');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
