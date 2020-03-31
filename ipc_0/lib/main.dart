import 'dart:async';
import 'dart:ffi';
import 'dart:io' show Platform;
import 'package:ffi/ffi.dart';


/**
 * 设置桌面窗口的标题
 */
// void setDesktopWindow(const char *title);

typedef setDesktopWindow_func = Void Function(Pointer<Utf8> title);
typedef setDesktopWindow = void Function(Pointer<Utf8> title);

/**
 * 设置抽屉窗口的标题
 */
// void setDrawerWindow(const char *title);

typedef setDrawerWindow_func = Void Function(Pointer<Utf8> title);
typedef setDrawerWindow = void Function(Pointer<Utf8> title);


/**
 * 设置窗口动画起点（icon位置）
 */
// void setWindowSource(const char *title, uint32_t x, uint32_t y);

typedef setWindowSource_func = Void Function(Pointer<Utf8> title, Uint32 x, Uint32 y);
typedef setWindowSource = void Function(Pointer<Utf8> title, int x, int y); // Dart does not have a native unsigned 64-bit integer. https://stackoverflow.com/questions/53589309/how-do-i-declare-64bit-unsigned-int-in-dart-flutter

/**
 * 应用设置（实际发送请求）
 */
// int flush();
typedef flush_func = Void Function();
typedef flush = void Function();


class IPC {
  static final String _dylibPath = "/mnt/hgfs/WeOS/plugins/ipc/client-sdk/libdisplayServiceSDK.so";
  static final DynamicLibrary _dylib = DynamicLibrary.open(_dylibPath);

  static void ipcSetDesktopWindow(String title) async {
    final _setDesktopWindow = _dylib
        .lookup<NativeFunction<setDesktopWindow_func>>('setDesktopWindow')
        .asFunction<setDesktopWindow>();
    return _setDesktopWindow(Utf8.toUtf8(title));
  }
}
