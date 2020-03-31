#import "BinderPlugin.h"
#if __has_include(<binder/binder-Swift.h>)
#import <binder/binder-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "binder-Swift.h"
#endif

@implementation BinderPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftBinderPlugin registerWithRegistrar:registrar];
}
@end
