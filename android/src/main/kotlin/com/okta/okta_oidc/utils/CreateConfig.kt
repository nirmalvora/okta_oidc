package com.okta.okta_oidc.utils

import android.content.Context
import android.graphics.Color
import com.google.gson.Gson
import com.okta.oidc.OIDCConfig
import com.okta.oidc.Okta
import com.okta.oidc.storage.SharedPreferenceStorage
import java.util.concurrent.Executors

fun createConfig(arguments: String?, context: Context) {
    try {
        val gson = Gson()
        val octaConfig =
            gson.fromJson(arguments, OktaConfig::class.java)
        val   config = OIDCConfig.Builder()
            .clientId(octaConfig!!.mClientId!!)
            .redirectUri(octaConfig.mRedirectUri!!)
            .endSessionRedirectUri(octaConfig.mEndSessionRedirectUri!!)
            .discoveryUri(octaConfig.mDiscoveryUri!!)
            .scopes(*octaConfig.mScopes!!.toTypedArray())
            .create()

        val  client = Okta.WebAuthBuilder()
            .withConfig(config)
            .withContext(context)
            .withStorage(SharedPreferenceStorage(context))
            .withCallbackExecutor(Executors.newSingleThreadExecutor())
            .setRequireHardwareBackedKeyStore(false)
            .withTabColor(Color.parseColor("#1B1917"))
            .supportedBrowsers("com.android.chrome", "org.mozilla.firefox", "com.microsoft.emmx")
            .browserMatchAll(true)
            .create()

        OktaClient.init(config, client)
        PendingOperation.success(true)
    } catch (ex: java.lang.Exception) {
        PendingOperation.error("okta not initialized","okta not initialized")
    }
}