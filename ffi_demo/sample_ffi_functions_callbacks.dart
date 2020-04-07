// 打开动态链接库
// 跟 dart 跟 c 进行交互
import 'dart:ffi';

import 'coordinate.dart';
import 'dylib_utils.dart';

typedef NativeCoordinateOp = Pointer<Coordinate> Function(Pointer<Coordinate>);

typedef CoordinateTrice = Pointer<Coordinate> Function(
    Pointer<NativeFunction<NativeCoordinateOp>>, Pointer<Coordinate>);

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

main() {
  print('start main');

  DynamicLibrary ffiTestFunctions =
      dlopenPlatformSpecific("ffi_test_functions");

  {
    // Pass a c pointer to a c function as an argument to a c function.
    // 传递一个 c 函数指针给一个 c 函数
    Pointer<NativeFunction<NativeCoordinateOp>> transposeCoordinatePointer =
        ffiTestFunctions.lookup("TransposeCoordinate"); // 查找 c 函数 TransposeCoordinate，定义为 c 函数指针
    Pointer<NativeFunction<CoordinateTrice>> p2 =
        ffiTestFunctions.lookup("CoordinateUnOpTrice");
    CoordinateTrice coordinateUnOpTrice = p2.asFunction();
    Coordinate c1 = Coordinate.allocate(10.0, 20.0, nullptr);
    c1.next = c1.addressOf; // 循环指针。。。
    Coordinate result =
        coordinateUnOpTrice(transposeCoordinatePointer, c1.addressOf).ref;
    print(result.runtimeType);
    print(result.x);
    print(result.y);
  }

  {
    // Return a c pointer to a c function from a c function.
    // 从 一个 c 函数返回一个 c 函数指针
    Pointer<NativeFunction<NativeIntptrBinOpLookup>> p14 =
        ffiTestFunctions.lookup("IntptrAdditionClosure");
    NativeIntptrBinOpLookup intptrAdditionClosure = p14.asFunction();

    Pointer<NativeFunction<NativeIntptrBinOp>> intptrAdditionPointer =
        intptrAdditionClosure();
    BinaryOp intptrAddition = intptrAdditionPointer.asFunction();
    print(intptrAddition(10, 27));
  }

  {
    // dart 函数 传递给 c 进行调用
    Pointer<NativeFunction<NativeIntptrBinOp>> pointer =
        Pointer.fromFunction(myPlus, 0); // dart 函数转换为 c 函数指针
    print(pointer);

    Pointer<NativeFunction<NativeApplyTo42And74Type>> p17 =
        ffiTestFunctions.lookup("ApplyTo42And74");
    ApplyTo42And74Type applyTo42And74 = p17.asFunction();

    int result = applyTo42And74(pointer); // 将 dart 函数传递给 c 函数作为回调
    print(result);
  }

  print("end main");
}
