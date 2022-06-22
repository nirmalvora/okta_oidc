import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'okta_oidc_method_channel.dart';

abstract class OktaOidcPlatform extends PlatformInterface {
  /// Constructs a OktaOidcPlatform.
  OktaOidcPlatform() : super(token: _token);

  static final Object _token = Object();

  static OktaOidcPlatform _instance = MethodChannelOktaOidc();

  /// The default instance of [OktaOidcPlatform] to use.
  ///
  /// Defaults to [MethodChannelOktaOidc].
  static OktaOidcPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [OktaOidcPlatform] when
  /// they register themselves.
  static set instance(OktaOidcPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<bool?> initOkta(Map<String, dynamic>? oktaConfig) {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<Map?> login() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<Map?> socialLogin(Map<String, String> map) {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<Map?> getAccessToken() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<bool?> logout() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<dynamic> getUserProfile() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
  
  Future<bool?> isAuthenticated() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
