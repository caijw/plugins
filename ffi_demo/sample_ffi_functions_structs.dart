// dart 和 c 的结构体 进行交互

import 'dart:ffi';

import 'coordinate.dart';
import 'dylib_utils.dart';

import 'package:ffi/ffi.dart';

typedef NativeCoordinateOp = Pointer<Coordinate> Function(Pointer<Coordinate>);

main() {
  print('start main');

  DynamicLibrary ffiTestFunctions =
      dlopenPlatformSpecific("ffi_test_functions");

  {
    // Pass a struct to a c function and get a struct as return value.
    // dart 传递一个 结构体给 c，c 返回一个 结构体给 dart
    Pointer<NativeFunction<NativeCoordinateOp>> p1 =
        ffiTestFunctions.lookup("TransposeCoordinate");
    NativeCoordinateOp f1 = p1.asFunction();

    Coordinate c1 = Coordinate.allocate(10.0, 20.0, nullptr);
    Coordinate c2 = Coordinate.allocate(42.0, 84.0, c1.addressOf);
    c1.next = c2.addressOf;

    Coordinate result = f1(c1.addressOf).ref;

    print('c1.x ${c1.x}');
    print('c1.y ${c1.y}');

    print('result.runtimeType ${result.runtimeType}');

    print('result.x ${result.x}');
    print('result.y ${result.y}');
  }

  {
    // Pass an array of structs to a c funtion.
    // 传递一个 结构体数组给 c 函数，返回数组的第二个元素
    Pointer<NativeFunction<NativeCoordinateOp>> p1 =
        ffiTestFunctions.lookup("CoordinateElemAt1");
    NativeCoordinateOp f1 = p1.asFunction();

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

    Coordinate result = f1(c1).ref;

    print(result.x);
    print(result.y);
  }

  print("end main");
}
