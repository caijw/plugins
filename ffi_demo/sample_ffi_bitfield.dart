// 在 dart 里面定义一个 c 结构体
// 然后对结构体的各个字段进行赋值
// TODO 还不是很理解结构体的各个字段是怎么实现的


import 'dart:ffi';

import 'package:ffi/ffi.dart';
// import 'package:expect/expect.dart';

/// typedef struct {
///     unsigned int bold      : 1;
///     unsigned int underline : 2;
///     unsigned int italic    : 1;
///     unsigned int blink     : 1;
///     unsigned int reverse   : 1;
///     unsigned int strike    : 1;
///     unsigned int font      : 4;
/// } ScreenCellAttrs;
class ScreenCellAttrs extends Struct {
  @Int16() //  a native signed 16 bit integer in C
  int bits;

  int get bold => getBits(kBoldFieldOffset, kBoldFieldLength);
  void set bold(int value) =>
      setBits(kBoldFieldOffset, kBoldFieldLength, value);

  int get underline => getBits(kUnderlineFieldOffset, kUnderlineFieldLength);
  void set underline(int value) =>
      setBits(kUnderlineFieldOffset, kUnderlineFieldLength, value);

  int get italic => getBits(kItalicFieldOffset, kItalicFieldLength);
  void set italic(int value) =>
      setBits(kItalicFieldOffset, kItalicFieldLength, value);

  int get blink => getBits(kBlinkFieldOffset, kBlinkFieldLength);
  void set blink(int value) =>
      setBits(kBlinkFieldOffset, kBlinkFieldLength, value);

  int get reverse => getBits(kReverseFieldOffset, kReverseFieldLength);
  void set reverse(int value) =>
      setBits(kReverseFieldOffset, kReverseFieldLength, value);

  int get strike => getBits(kStrikeFieldOffset, kStrikeFieldLength);
  void set strike(int value) =>
      setBits(kStrikeFieldOffset, kStrikeFieldLength, value);

  int get font => getBits(kFontFieldOffset, kFontFieldLength);
  void set font(int value) =>
      setBits(kFontFieldOffset, kFontFieldLength, value);

  int getBits(int offset, int length) => bits.getBits(offset, length);

  void setBits(int offset, int length, int value) {
    bits = bits.setBits(offset, length, value);
  }
}

const int kBoldFieldOffset = 0;
const int kBoldFieldLength = 1;
const int kUnderlineFieldOffset = kBoldFieldOffset + kBoldFieldLength;
const int kUnderlineFieldLength = 2;
const int kItalicFieldOffset = kUnderlineFieldOffset + kUnderlineFieldLength;
const int kItalicFieldLength = 1;
const int kBlinkFieldOffset = kItalicFieldOffset + kItalicFieldLength;
const int kBlinkFieldLength = 1;
const int kReverseFieldOffset = kBlinkFieldOffset + kBlinkFieldLength;
const int kReverseFieldLength = 1;
const int kStrikeFieldOffset = kReverseFieldOffset + kReverseFieldLength;
const int kStrikeFieldLength = 1;
const int kFontFieldOffset = kStrikeFieldOffset + kStrikeFieldLength;
const int kFontFieldLength = 4;


/// Extension to use a 64-bit integer as bit field.
// 扩展 int 的 IntBitField
extension IntBitField on int {
  static int _bitMask(int offset, int lenght) => ((1 << lenght) - 1) << offset;

  /// Read `length` bits at `offset`.
  ///
  /// Truncates everything.
  int getBits(int offset, int length) {
    final mask = _bitMask(offset, length);
    return (this & mask) >> offset;
  }

  /// Returns a new integer value in which `length` bits are overwritten at
  /// `offset`.
  ///
  /// Truncates everything.
  int setBits(int offset, int length, int value) {
    final mask = _bitMask(offset, length);
    return (this & ~mask) | ((value << offset) & mask);
  }
}

main() {

  // int tmp = 12345678901234567890;
  // print('tmp: ${tmp}');

  final p = allocate<ScreenCellAttrs>(count: 1); // 申请 cout 个 ScreenCellAttrs 对象的空间

  // Zeroes out all fields.
  p.ref.bits = 0;

  // Set individual fields.
  p.ref.blink = 0;
  p.ref.bold = 1;
  p.ref.font = 15;
  p.ref.italic = 1;
  p.ref.reverse = 0;
  p.ref.strike = 0;
  p.ref.underline = 2;

  // Read individual fields.
  print(p.ref.blink);
  print(p.ref.bold);
  print(p.ref.font);
  print(p.ref.italic);
  print(p.ref.reverse);
  print(p.ref.strike);
  print(p.ref.underline);

  // A check for automated testing.
  assert(1933 == p.ref.bits);

  free(p);
}
