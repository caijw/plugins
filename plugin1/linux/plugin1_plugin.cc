#include "plugin1_plugin.h"

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_glfw.h>
#include <flutter/standard_method_codec.h>
#include <sys/utsname.h>

#include <map>
#include <memory>
#include <sstream>

namespace {

std::unique_ptr<flutter::MethodChannel<flutter::EncodableValue>> channel_;

class Plugin1Plugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarGlfw *registrar);
  
  Plugin1Plugin();

  virtual ~Plugin1Plugin();

 private:
  
  // std::unique_ptr<flutter::MethodChannel<flutter::EncodableValue>> channel2_;

  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

// static
void Plugin1Plugin::RegisterWithRegistrar(
    flutter::PluginRegistrarGlfw *registrar) {
  channel_ =
      std::make_unique<flutter::MethodChannel<flutter::EncodableValue>>(
          registrar->messenger(), "plugin1",
          &flutter::StandardMethodCodec::GetInstance());
  auto plugin = std::make_unique<Plugin1Plugin>();

  channel_->SetMethodCallHandler(
      [plugin_pointer = plugin.get()](const auto &call, auto result) {
        plugin_pointer->HandleMethodCall(call, std::move(result));
      });

  registrar->AddPlugin(std::move(plugin));

}

Plugin1Plugin::Plugin1Plugin() {}

Plugin1Plugin::~Plugin1Plugin() {}

void Plugin1Plugin::HandleMethodCall(
    const flutter::MethodCall<flutter::EncodableValue> &method_call,
    std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  // Replace "getPlatformVersion" check with your plugin's method.
  // See:
  // https://github.com/flutter/engine/tree/master/shell/platform/common/cpp/client_wrapper/include/flutter
  // and
  // https://github.com/flutter/engine/tree/master/shell/platform/glfw/client_wrapper/include/flutter
  // for the relevant Flutter APIs.
  if (method_call.method_name().compare("getPlatformVersion") == 0) {

    
    channel_->InvokeMethod("getPlatformVersionBack", std::make_unique<flutter::EncodableValue>("getPlatformVersionBack"));

    struct utsname uname_data = {};
    uname(&uname_data);
    std::ostringstream version_stream;
    version_stream << "Linux " << uname_data.version;
    flutter::EncodableValue response(version_stream.str());
    result->Success(&response);

  
    // channel_->InvokeMethod("getPlatformVersion", nullptr);
  } else if (method_call.method_name().compare("echoBigString") == 0) {
    flutter::EncodableValue response(method_call.arguments()->StringValue());
    result->Success(&response);
  } else {
    result->NotImplemented();
  }
}

}  // namespace

void Plugin1PluginRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  // The plugin registrar wrappers owns the plugins, registered callbacks, etc.,
  // so must remain valid for the life of the application.
  static auto *plugin_registrars =
      new std::map<FlutterDesktopPluginRegistrarRef,
                   std::unique_ptr<flutter::PluginRegistrarGlfw>>;
  auto insert_result = plugin_registrars->emplace(
      registrar, std::make_unique<flutter::PluginRegistrarGlfw>(registrar));

  Plugin1Plugin::RegisterWithRegistrar(insert_result.first->second.get());
}
