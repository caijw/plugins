// dart 和 c 进行 c 结构体交互

import 'dart:ffi';

import 'package:ffi/ffi.dart';

import 'coordinate.dart';

import 'dylib_utils.dart';

typedef NativeGetAppList = Int32 Function(Pointer<Pointer<AppInfo>> app_info_list, Pointer<Int32> length);
typedef GetAppList = int Function(Pointer<Pointer<AppInfo>> app_info_list, Pointer<Int32> length);

class App_Info {
  String appid = '';
  String nickname = '';
  String icon = '';
  App_Info(String appid_, String nickname_, String icon_) {
    appid = appid_;
    nickname = nickname_;
    icon = icon_;
  }
}

main() {
  print('start main');

  {
    // 一个循环链表，元素是分割的
    // Allocates each coordinate separately in c memory.
    Coordinate c1 = Coordinate.allocate(10.0, 10.0, nullptr);
    Coordinate c2 = Coordinate.allocate(20.0, 20.0, c1.addressOf);
    Coordinate c3 = Coordinate.allocate(30.0, 30.0, c2.addressOf);
    c1.next = c3.addressOf;

    Coordinate currentCoordinate = c1;
    for (var i in [0, 1, 2, 3, 4]) {
      currentCoordinate = currentCoordinate.next.ref;
      print("${currentCoordinate.x}; ${currentCoordinate.y}");
    }

    free(c1.addressOf);
    free(c2.addressOf);
    free(c3.addressOf);
  }

  {
    // 连续内存的循环链表
    // Allocates coordinates consecutively in c memory.
    Pointer<Coordinate> c1 = allocate<Coordinate>(count: 3);
    Pointer<Coordinate> c2 = c1.elementAt(1);
    Pointer<Coordinate> c3 = c1.elementAt(2);
    c1.ref.x = 10.0;
    c1.ref.y = 10.0;
    c1.ref.next = c3;
    c2.ref.x = 20.0;
    c2.ref.y = 20.0;
    c2.ref.next = c1;
    c3.ref.x = 30.0;
    c3.ref.y = 30.0;
    c3.ref.next = c2;

    Coordinate currentCoordinate = c1.ref;
    for (var i in [0, 1, 2, 3, 4]) {
      currentCoordinate = currentCoordinate.next.ref;
      print("${currentCoordinate.x}; ${currentCoordinate.y}");
    }

    free(c1);
  }

  {
    Coordinate c = Coordinate.allocate(10, 10, nullptr);
    print(c is Coordinate);
    print(c is Pointer<Void>);
    print(c is Pointer);
    free(c.addressOf);
  }

  {
    print('begin getAppList');
    DynamicLibrary ffiTestFunctions = dlopenPlatformSpecific("ffi_test_functions");
    Pointer<Pointer<AppInfo>> app_info_list = allocate<Pointer<AppInfo>>(count: 1);
    Pointer<Int32> length = allocate<Int32>(count: 1);

    GetAppList getAppList = ffiTestFunctions.lookupFunction<NativeGetAppList, GetAppList>("getAppList");

    int ret = getAppList(app_info_list, length);
    print('getAppList ret: ${ret}');
    print('length.value: ${length.value}');
    List<App_Info> app_infos = [];
    if (ret == 0) {
      Pointer<AppInfo> p = app_info_list.value;
      for (int i = 0; i < length.value; ++i) {
        App_Info app_info = App_Info( Utf8.fromUtf8(p.elementAt(i).ref.appid), Utf8.fromUtf8(p.elementAt(i).ref.nickname), Utf8.fromUtf8(p.elementAt(i).ref.icon) );
        app_infos.add(app_info);
        free(p.elementAt(i).ref.appid);
        free(p.elementAt(i).ref.nickname);
        free(p.elementAt(i).ref.icon);
      }
      free(app_info_list.value);
      print('app_infos:');
      for (int i = 0; i < app_infos.length; ++i) {
        print('[${i}]appid: ${app_infos[i].appid}, nickname: ${app_infos[i].nickname}, icon: ${app_infos[i].icon}');
      }
    }



  }

  print("end main");
}
