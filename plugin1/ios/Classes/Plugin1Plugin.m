#import "Plugin1Plugin.h"
#if __has_include(<plugin1/plugin1-Swift.h>)
#import <plugin1/plugin1-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "plugin1-Swift.h"
#endif

@implementation Plugin1Plugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftPlugin1Plugin registerWithRegistrar:registrar];
}
@end
