library binder;
import 'dart:async';
import 'dart:ui';
import 'package:flutter/services.dart';

/// The name of the plugin's platform channel.
const String _kChannel = 'flutter/binder';

/// The method name to instruct the native plugin to show the panel.
const String _kSayHelloPanelMethod = 'Binder.sayHello';

/// The method name to instruct the native plugin to hide the panel.
const String _krandomPanelMethod = 'Binder.random';

const MethodChannel _platformChannel = const MethodChannel(_kChannel);

typedef RandomCallback = void Function(int num);

/// A Calculator.
class Binder {
  RandomCallback _callback;
  Binder() {
    // 设置 channel 消息通知回调
    _platformChannel.setMethodCallHandler(_wrappedPanelCallback);
  }
  void sayHello() {
    print("[plugin dart]Binder.sayHello call");
    print("[plugin dart]before _platformChannel.invokeMethod call");
    _platformChannel.invokeMethod(_kSayHelloPanelMethod);
    print("[plugin dart]after _platformChannel.invokeMethod call");
  }
  int random(RandomCallback callback) {
    print("[plugin dart]Binder.random call");
    print("[plugin dart]before _platformChannel.invokeMethod call");
    _callback = callback;
    _platformChannel.invokeMethod(_krandomPanelMethod);
    print("[plugin dart]after _platformChannel.invokeMethod call");
    return 0;
  }
  /// Mediates between the platform channel callback and the client callback.
  Future<Null> _wrappedPanelCallback(MethodCall methodCall) async {
    print("[plugin dart]Binder._wrappedPanelCallback call");
    if (methodCall.method == _kSayHelloPanelMethod) {
      // do nothing
      print("[plugin dart]sayHello");
    } else if (_callback != null &&
        methodCall.method == _krandomPanelMethod) {
      try {
        print("[plugin dart]random");
        print(methodCall.arguments);
        final int arg = methodCall.arguments;
        print("[plugin dart]random arg ${arg}");
        _callback(arg);
      } on Exception catch (e, s) {
        print('Exception in callback handler: $e\n$s');
      }
    }

  }
}



