// Copyright (c) 2020, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
//
// Sample showing how to do async callbacks by telling the Dart isolate to
// yields its execution thread to C so it can perform the callbacks on the
// main Dart thread.
//
// TODO(dartbug.com/37022): Update this when we get real async callbacks.

import 'dart:ffi';
import 'dart:isolate';

// import 'package:expect/expect.dart';

import '../dylib_utils.dart';

int globalResult = 0;
int numCallbacks1 = 0;
int numCallbacks2 = 0;

main() async {
  print("Dart = Dart mutator thread executing Dart.");
  print("C Da = Dart mutator thread executing C.");
  print("C T1 = Some C thread executing C.");
  print("C T2 = Some C thread executing C.");
  print("C    = C T1 or C T2.");
  print("Dart: Setup.");
  // 生成 port
  registerDart_PostCObject(NativeApi.postCObject);

  final interactiveCppRequests = ReceivePort()..listen(requestExecuteCallback);

  // 传递给 c 的 sendPort id
  final int nativePort = interactiveCppRequests.sendPort.nativePort;

  // 函数指针注册给 c  
  registerCallback1(nativePort, callback1FP);
  // 函数指针注册给 c
  registerCallback2(nativePort, callback2FP);

  print("Dart: Tell C to start worker threads.");
  // 启动 c 多线程
  startWorkSimulator();

  // We need to yield control in order to be able to receive messages.
  while (numCallbacks2 < 3) {
    print("Dart: Yielding (able to receive messages on port).");
    await asyncSleep(500);
  }
  print("Dart: Received expected number of callbacks.");
  assert(2 == numCallbacks1);
  assert(3 == numCallbacks2);
  assert(14 == globalResult); // 0 + (5+3) + (3 + 3)
  // Expect.equals(2, numCallbacks1);
  // Expect.equals(3, numCallbacks2);
  // Expect.equals(14, globalResult);

  print("Dart: Tell C to stop worker threads.");
  stopWorkSimulator();
  interactiveCppRequests.close();
  print("Dart: Done.");
}
// c 调用了两次
int callback1(int a) {
  print("Dart:     callback1($a).");
  numCallbacks1++;
  return a + 3;
}
// c 调用了三次
void callback2(int a) {
  print("Dart:     callback2($a).");
  globalResult += a;
  numCallbacks2++;
}

void requestExecuteCallback(dynamic message) {
  final int work_address = message;
  final work = Pointer<Work>.fromAddress(work_address);
  print("Dart:   Calling into C to execute callback ($work).");
  executeCallback(work);
  print("Dart:   Done with callback.");
}

final callback1FP = Pointer.fromFunction<IntPtr Function(IntPtr)>(callback1, 0);

final callback2FP = Pointer.fromFunction<Void Function(IntPtr)>(callback2);

final dl = dlopenPlatformSpecific("ffi_test_functions_vmspecific");

final registerCallback1 = dl.lookupFunction<
        Void Function(Int64 sendPort,
            Pointer<NativeFunction<IntPtr Function(IntPtr)>> functionPointer),
        void Function(int sendPort,
            Pointer<NativeFunction<IntPtr Function(IntPtr)>> functionPointer)>(
    'RegisterMyCallbackBlocking');

final registerCallback2 = dl.lookupFunction<
        Void Function(Int64 sendPort,
            Pointer<NativeFunction<Void Function(IntPtr)>> functionPointer),
        void Function(int sendPort,
            Pointer<NativeFunction<Void Function(IntPtr)>> functionPointer)>(
    'RegisterMyCallbackNonBlocking');

final startWorkSimulator =
    dl.lookupFunction<Void Function(), void Function()>('StartWorkSimulator');

final stopWorkSimulator =
    dl.lookupFunction<Void Function(), void Function()>('StopWorkSimulator');

final executeCallback = dl.lookupFunction<Void Function(Pointer<Work>),
    void Function(Pointer<Work>)>('ExecuteCallback');

final registerDart_PostCObject = dl.lookupFunction<
    Void Function(
        Pointer<NativeFunction<Int8 Function(Int64, Pointer<Dart_CObject>)>>
            functionPointer),
    void Function(
        Pointer<NativeFunction<Int8 Function(Int64, Pointer<Dart_CObject>)>>
            functionPointer)>('RegisterDart_PostCObject');

class Work extends Struct {

}

Future asyncSleep(int ms) {
  return new Future.delayed(Duration(milliseconds: ms));
}
