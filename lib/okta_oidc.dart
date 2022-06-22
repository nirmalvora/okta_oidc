import 'okta_oidc_platform_interface.dart';

class OktaOidc {
  Future<bool?> initOkta(Map<String, dynamic>? oktaConfig) {
    if (oktaConfig != null) {
      if (oktaConfig['client_id'] == null || oktaConfig['client_id'] == "") {
        throw UnimplementedError("Please provide valid okta client id");
      } else if (oktaConfig['redirect_uri'] == null ||
          oktaConfig['redirect_uri'] == "") {
        throw UnimplementedError("Please provide valid okta redirect uri");
      } else if (oktaConfig['end_session_redirect_uri'] == null ||
          oktaConfig['end_session_redirect_uri'] == "") {
        throw UnimplementedError(
            "Please provide valid okta end session redirect uri");
      } else if (oktaConfig['discovery_uri'] == null ||
          oktaConfig['discovery_uri'] == "") {
        throw UnimplementedError("Please provide valid okta discovery uri");
      }
      return OktaOidcPlatform.instance.initOkta(oktaConfig);
    } else {
      throw UnimplementedError("Please provide valid okta config");
    }
  }

  Future<Map?> login() {
    return OktaOidcPlatform.instance.login();
  }

  Future<Map?> socialLogin(Map<String, String> map) {
    return OktaOidcPlatform.instance.socialLogin(map);
  }

  Future<Map?> getAccessToken() {
    return OktaOidcPlatform.instance.getAccessToken();
  }

  Future<bool?> logout() {
    return OktaOidcPlatform.instance.logout();
  }

  Future<dynamic> getUserProfile() {
    return OktaOidcPlatform.instance.getUserProfile();
  }
 
  Future<bool?> isAuthenticated() {
    return OktaOidcPlatform.instance.isAuthenticated();
  }
}
