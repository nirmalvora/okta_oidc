package com.okta.okta_oidc.utils
import com.google.gson.annotations.SerializedName
class OktaConfig internal constructor() {
  @SerializedName("client_id")
  var mClientId: String? = null

  @SerializedName("redirect_uri")
  var mRedirectUri: String? = null

  @SerializedName("end_session_redirect_uri")
  var mEndSessionRedirectUri: String? = null

  @SerializedName("scopes")
  var mScopes: ArrayList<String>? = null

  @SerializedName("discovery_uri")
  var mDiscoveryUri: String? = null
}