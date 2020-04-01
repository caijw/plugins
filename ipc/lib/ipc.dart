// TODO: 这个包是手写的，后面弄个工具自动生成
// warning: only for linux, 只有调用 flush 才会发送实际的请求给 server
library ipc;

import 'dart:async';
import 'dart:ffi';
import 'dart:io' show Platform;
import 'package:ffi/ffi.dart';

// void setDesktopWindow(const char *title);
typedef _setDesktopWindow_func = Void Function(Pointer<Utf8> title);
typedef _setDesktopWindow = void Function(Pointer<Utf8> title);

// void setDrawerWindow(const char *title);
typedef _setDrawerWindow_func = Void Function(Pointer<Utf8> title);
typedef _setDrawerWindow = void Function(Pointer<Utf8> title);

// void setWindowSource(const char *title, uint32_t x, uint32_t y);
typedef _setWindowSource_func = Void Function(Pointer<Utf8> title, Uint32 x, Uint32 y);
typedef _setWindowSource = void Function(Pointer<Utf8> title, int x, int y); // Dart does not have a native unsigned 64-bit integer. https://stackoverflow.com/questions/53589309/how-do-i-declare-64bit-unsigned-int-in-dart-flutter

// int flush();
typedef _flush_func = Int32 Function();
typedef _flush = int Function();


class IPC {
  static final String _dylibPath = Platform.environment['weos_client_sdk_path'] + '/libdisplayServiceSDK.so';
  static final DynamicLibrary _dylib = DynamicLibrary.open(_dylibPath);
  /**
   * 设置桌面窗口的标题
   */
  static void setDesktopWindow(String title) async {
    final setDesktopWindow_func = _dylib
        .lookup<NativeFunction<_setDesktopWindow_func>>('setDesktopWindow')
        .asFunction<_setDesktopWindow>();
    return setDesktopWindow_func(Utf8.toUtf8(title));
  }
  /**
   * 设置抽屉窗口的标题
   */
  static void setDrawerWindow(String title) async {
    final setDrawerWindow_func = _dylib
        .lookup<NativeFunction<_setDrawerWindow_func>>('setDrawerWindow')
        .asFunction<_setDrawerWindow>();
    return setDrawerWindow_func(Utf8.toUtf8(title));
  }
  /**
   * 设置窗口动画起点（icon位置）
   */
  static void setWindowSource(String title, int x, int y) async {
    final setWindowSource_func = _dylib
        .lookup<NativeFunction<_setWindowSource_func>>('setWindowSource')
        .asFunction<_setWindowSource>();
    return setWindowSource_func(Utf8.toUtf8(title), x, y);
  }
  /**
   * 应用设置（实际发送请求）
   */
  static Future<int> flush() async {
    final flush_func = _dylib
        .lookup<NativeFunction<_flush_func>>('flush')
        .asFunction<_flush>();
    return flush_func();
  }
}
