// Sample illustrating resources are not cleaned up when isolate is shutdown.
// 在新的 isolate 里面操作资源
import 'dart:io';
import "dart:isolate";
import 'dart:ffi';

// import 'package:expect/expect.dart';

import 'pool.dart';
import '../dylib_utils.dart';

void main() {
  final receiveFromHelper = ReceivePort();

  Isolate.spawn(helperIsolateMain, receiveFromHelper.sendPort)
      .then((helperIsolate) {
    helperIsolate.addOnExitListener(
      receiveFromHelper.sendPort,
    );
    print("Main: Helper started.");
    Pointer<SomeResource> resource;
    // 这部分的逻辑：
    // 子 isolate 发送一个 resource 的地址过来
    // main ioslate 收到后，主动执行将子 isolate 关闭
    // 子 isolate 发送null 消息告诉 main isolate 他被关闭了，main isolate 访问缓存起来的资源地址后释放资源地址
    receiveFromHelper.listen((message) {
      if (message is int) {
        resource = Pointer<SomeResource>.fromAddress(message);
        print("Main: Received resource from helper: $resource.");
        print("Main: Shutting down helper.");
        helperIsolate.kill(priority: Isolate.immediate);
      } else {
        // Isolate kill message.
        assert(message == null);
        // Expect.isNull(message);
        print("Main: Helper is shut down.");
        print(
            "Main: Trying to use resource after isolate that was supposed to free it was shut down.");
        useResource(resource);
        print("Main: Releasing resource manually.");
        releaseResource(resource);
        print("Main: Shutting down receive port, end of main.");
        receiveFromHelper.close();
      }
    });
  });
}

/// If set to `false`, this sample can segfault due to use after free and
/// double free.
// 如果这个字段设置为 false ，那么子 isolate 执行一遍就结束了，资源主动释放了
// 那么 main isolate 再访问已经释放的资源，并且再次进行释放，会有 Segmentation
const keepHelperIsolateAlive = true;

void helperIsolateMain(SendPort sendToMain) {
  using((Pool pool) {
    final resource = pool.using(allocateResource(), releaseResource); // using pool 的函数执行完，就会释放
    pool.onReleaseAll(() {
      // Will only run print if [keepHelperIsolateAlive] is false.
      print("Helper: Releasing all resources.");
    });
    print("Helper: Resource allocated.");
    useResource(resource);
    print("Helper: Sending resource to main: $resource.");
    sendToMain.send(resource.address);
    print("Helper: Going to sleep.");
    if (keepHelperIsolateAlive) {
      while (true) {
        sleep(Duration(seconds: 1));
        print("Helper: sleeping.");
      }
    }
  });
}

final ffiTestDynamicLibrary =
    dlopenPlatformSpecific("ffi_test_dynamic_library");

final allocateResource = ffiTestDynamicLibrary.lookupFunction<
    Pointer<SomeResource> Function(),
    Pointer<SomeResource> Function()>("AllocateResource");

final useResource = ffiTestDynamicLibrary.lookupFunction<
    Void Function(Pointer<SomeResource>),
    void Function(Pointer<SomeResource>)>("UseResource");

final releaseResource = ffiTestDynamicLibrary.lookupFunction<
    Void Function(Pointer<SomeResource>),
    void Function(Pointer<SomeResource>)>("ReleaseResource");

/// Represents some opaque resource being managed by a library.
class SomeResource extends Struct {}
