// 打开动态链接库

import 'dart:ffi';

import 'dylib_utils.dart';

typedef NativeDoubleUnOp = Double Function(Double);

typedef DoubleUnOp = double Function(double);

int main() {
  DynamicLibrary l = dlopenPlatformSpecific("ffi_test_dynamic_library");
  print(l);
  print(l.runtimeType);

  var timesFour = l.lookupFunction<NativeDoubleUnOp, DoubleUnOp>("timesFour");
  print(timesFour);
  print(timesFour.runtimeType);

  print(timesFour(3.0));
}
