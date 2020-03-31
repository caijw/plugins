#ifndef BINDER_TEST_CLIENT_H
#define BINDER_TEST_CLIENT_H

#include "IBasicService.h"
#include <iostream>

class Client {
private:
    Client();
    ~Client();
    Client(const Client&);
    Client& operator=(const Client&);
public:
    static Client& getInstance();
    void sayHello();
};

// PLUGIN_EXPORT 宏: 编译的时候不要隐藏该符号，暴露给调用者
#define PLUGIN_EXPORT __attribute__((visibility("default")))

#if defined(__cplusplus)
extern "C" {
#endif

// 暴露给 dart 调用的 c 函数
PLUGIN_EXPORT void sayHello();

PLUGIN_EXPORT void hello_world();



#if defined(__cplusplus)
}  // extern "C"
#endif


#endif

