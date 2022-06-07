import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:okta_oidc/okta_oidc.dart';

class OktaLoginUtils {
  final _oktaOidcPlugin = OktaOidc();
  static final OktaLoginUtils _singleton = OktaLoginUtils._internal();

  factory OktaLoginUtils() {
    return _singleton;
  }

  OktaLoginUtils._internal();
  Map<String, dynamic>? oktaConfig;
  Future<bool?> initOkta() async {
    final String response =
        await rootBundle.loadString('assets/okta_config.json');
    oktaConfig = jsonDecode(response);
    return _oktaOidcPlugin.initOkta(oktaConfig);
  }

  Future<Map?> login() async {
    return _oktaOidcPlugin.login();
  }

  socialLogin() async {
    _oktaOidcPlugin.socialLogin({
      "idp": "0oa11t5hlpcImo4BX0h8",
      "idp-scope": "r_liteprofile r_emailaddress"
    }).then((value) {
      print(value);
    });
  }

  Future<Map?> getAccessToken() async {
    return _oktaOidcPlugin.getAccessToken().then((value) {
      print(value);
    });
  }

  Future<bool?> logout() async {
    return _oktaOidcPlugin.logout();
  }

  Future<dynamic> getUserProfile() async {
    return _oktaOidcPlugin.getUserProfile();
  }
}
