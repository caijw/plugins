#ifndef PLUGINS_COLOR_PANEL_LINUX_COLOR_PANEL_PLUGIN_H_
#define PLUGINS_COLOR_PANEL_LINUX_COLOR_PANEL_PLUGIN_H_

// A plugin for communicating with a native color picker panel.

#include <flutter_plugin_registrar.h>

#ifdef FLUTTER_PLUGIN_IMPL
#define FLUTTER_PLUGIN_EXPORT __attribute__((visibility("default")))
#else
#define FLUTTER_PLUGIN_EXPORT
#endif

#if defined(__cplusplus)
extern "C" {
#endif

FLUTTER_PLUGIN_EXPORT void BinderPluginRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar);

#if defined(__cplusplus)
}  // extern "C"
#endif

#endif  // PLUGINS_COLOR_PANEL_LINUX_COLOR_PANEL_PLUGIN_H_
