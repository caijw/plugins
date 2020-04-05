// c 结构体 Coordinate 的 dart 表示

import 'dart:ffi';

import "package:ffi/ffi.dart";

/// Sample struct for dart:ffi library.
class Coordinate extends Struct {
  @Double()
  double x;

  @Double()
  double y;

  Pointer<Coordinate> next;

  factory Coordinate.allocate(double x, double y, Pointer<Coordinate> next) {
    return allocate<Coordinate>().ref
      ..x = x
      ..y = y
      ..next = next;
  }
}
