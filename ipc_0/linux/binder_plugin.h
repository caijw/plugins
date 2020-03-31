#ifndef FLUTTER_PLUGIN_BINDER_PLUGIN_H_
#define FLUTTER_PLUGIN_BINDER_PLUGIN_H_

#include <flutter_plugin_registrar.h>

#ifdef FLUTTER_PLUGIN_IMPL
#define FLUTTER_PLUGIN_EXPORT __attribute__((visibility("default")))
#else
#define FLUTTER_PLUGIN_EXPORT
#endif

/*
extern "C"的真实目的是实现类C和C++的混合编程。
在C++源文件中的语句前面加上extern "C"，
表明它按照类C的编译和连接规约来编译和连接，
而不是C++的编译的连接规约。
这样在类C的代码中就可以调用C++的函数or变量等。
*/

#if defined(__cplusplus)
extern "C" {
#endif

FLUTTER_PLUGIN_EXPORT void BinderPluginRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar);

#if defined(__cplusplus)
}  // extern "C"
#endif

#endif  // FLUTTER_PLUGIN_BINDER_PLUGIN_H_
