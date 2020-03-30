#include "plugins/binder/linux/binder_plugin.h"

#include <iostream>
#include <memory>

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar.h>
#include <flutter/standard_method_codec.h>

#include "IBasicService.h"

namespace plugins_binder {

namespace {
// See color_panel.dart for documentation.
const char kChannelName[] = "flutter/binder";
const char kSayHelloPanelMethod[] = "Binder.sayHello";
const char krandomPanelMethod[] = "Binder.random";

}

using flutter::EncodableMap;
using flutter::EncodableValue;

class BinderPlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrar *registrar);
  virtual ~BinderPlugin();


 private:
  // Creates a plugin that communicates on the given channel.
  BinderPlugin(
      std::unique_ptr<flutter::MethodChannel<flutter::EncodableValue>> channel);

  // Called when a method is called on |channel_|;
  void HandleMethodCall(
      const flutter::MethodCall<EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<EncodableValue>> result);

  // The MethodChannel used for communication with the Flutter engine.
  std::unique_ptr<flutter::MethodChannel<EncodableValue>> channel_;
  sp<IBasicService> service_;
};


// static
void BinderPlugin::RegisterWithRegistrar(
    flutter::PluginRegistrar *registrar) {
  auto channel = std::make_unique<flutter::MethodChannel<EncodableValue>>(
      registrar->messenger(), kChannelName,
      &flutter::StandardMethodCodec::GetInstance());
  auto *channel_pointer = channel.get();

  // Uses new instead of make_unique due to private constructor.
  std::unique_ptr<BinderPlugin> plugin(
      new BinderPlugin(std::move(channel)));

  channel_pointer->SetMethodCallHandler(
      [plugin_pointer = plugin.get()](const auto &call, auto result) {
        plugin_pointer->HandleMethodCall(call, std::move(result));
      });

  registrar->AddPlugin(std::move(plugin));
}

BinderPlugin::BinderPlugin(
    std::unique_ptr<flutter::MethodChannel<EncodableValue>> channel)
    : channel_(std::move(channel)) {
      sp<IServiceManager> sm = defaultServiceManager();
      sp<IBinder> binder = sm->getService(String16("service.basic"));
      service_ = interface_cast<IBasicService>(binder);
    }

BinderPlugin::~BinderPlugin() {}

void BinderPlugin::HandleMethodCall(
    const flutter::MethodCall<EncodableValue> &method_call,
    std::unique_ptr<flutter::MethodResult<EncodableValue>> result) {
  if (method_call.method_name().compare(kSayHelloPanelMethod) == 0) {
    std::cerr << "[plugin c++]before service sayHello" << std::endl;
    // binder call
	  service_->sayHello();
    std::cerr << "[plugin c++]after service sayHello" << std::endl;
    result->Success();
  } else if (method_call.method_name().compare(krandomPanelMethod) == 0) {
    std::cerr << "[plugin c++]before service random" << std::endl;
    int32_t value = service_->random();
    std::cerr << "[plugin c++]service get random " << value << std::endl;
    channel_->InvokeMethod(krandomPanelMethod, std::make_unique<EncodableValue>( EncodableValue(value) ));
    std::cerr << "[plugin c++]after service random" << std::endl;
    result->Success();
  } else {
    result->NotImplemented();
  }
}


}  // namespace plugins_binder

// Register entry
void BinderPluginRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  // The plugin registrar owns the plugin, registered callbacks, etc., so must
  // remain valid for the life of the application.
  static auto *plugin_registrar = new flutter::PluginRegistrar(registrar);
  plugins_binder::BinderPlugin::RegisterWithRegistrar(
      plugin_registrar);
}
