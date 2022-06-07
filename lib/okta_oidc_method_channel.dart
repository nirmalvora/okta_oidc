import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'okta_oidc_platform_interface.dart';

/// An implementation of [OktaOidcPlatform] that uses method channels.
class MethodChannelOktaOidc extends OktaOidcPlatform {
  bool isInitialize = false;

  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('okta_oidc');

  @override
  Future<bool?> initOkta(Map<String, dynamic>? oktaConfig) async {
    final initStatus = await methodChannel.invokeMethod<bool>(
        'initialize-okta', {'config': jsonEncode(oktaConfig)});
    isInitialize = initStatus ?? false;
    return initStatus;
  }

  @override
  Future<Map?> login() async {
    if (isInitialize) {
      final loginResponse = await methodChannel.invokeMethod<Map>('sign-in');
      return loginResponse;
    } else {
      return {"status": false, "message": "okta not initializeed"};
    }
  }

  @override
  Future<Map?> socialLogin(Map<String, String> map) async {
    if (isInitialize) {
      final loginResponse =
          await methodChannel.invokeMethod<Map>('social-login', map);
      return loginResponse;
    } else {
      return {"status": false, "message": "okta not initializeed"};
    }
  }

  @override
  Future<Map?> getAccessToken() async {
    if (isInitialize) {
      final accessToken =
          await methodChannel.invokeMethod<Map>('get-access-token');
      return accessToken;
    } else {
      return {"status": false, "message": "okta not initializeed"};
    }
  }

  @override
  Future<bool?> logout() async {
    if (isInitialize) {
      final logoutStatus = await methodChannel.invokeMethod<bool>('logout');
      return logoutStatus;
    } else {
      return false;
    }
  }

  @override
  Future<dynamic> getUserProfile() async {
    if (isInitialize) {
      final userProfile =
          await methodChannel.invokeMethod<dynamic>('get-user-profile');
      return userProfile;
    } else {
      throw FlutterError("okta not initialize");
    }
  }
}
