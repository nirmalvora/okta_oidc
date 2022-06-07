#import "OktaOidcPlugin.h"
#if __has_include(<okta_oidc/okta_oidc-Swift.h>)
#import <okta_oidc/okta_oidc-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "okta_oidc-Swift.h"
#endif

@implementation OktaOidcPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftOktaOidcPlugin registerWithRegistrar:registrar];
}
@end
