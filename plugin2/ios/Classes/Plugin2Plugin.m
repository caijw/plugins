#import "Plugin2Plugin.h"
#if __has_include(<plugin2/plugin2-Swift.h>)
#import <plugin2/plugin2-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "plugin2-Swift.h"
#endif

@implementation Plugin2Plugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftPlugin2Plugin registerWithRegistrar:registrar];
}
@end
