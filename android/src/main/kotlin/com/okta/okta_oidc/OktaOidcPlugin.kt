package com.okta.okta_oidc

import android.app.Activity
import android.content.Context
import android.content.Intent
import androidx.annotation.NonNull
import com.okta.okta_oidc.utils.*
import com.okta.okta_oidc.utils.createConfig

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry
import io.flutter.plugin.common.PluginRegistry.Registrar
/** OktaOidcPlugin */
class OktaOidcPlugin: FlutterPlugin, MethodCallHandler,
  PluginRegistry.ActivityResultListener, ActivityAware {
  private lateinit var channel: MethodChannel

  private var applicationContext: Context? = null
  private var mainActivity: Activity? = null

  companion object {
    fun registerWith(registrar: Registrar) {
      val plugin = OktaOidcPlugin()
      registrar.activity()?.let { plugin.setActivity(it) }
      plugin.onAttachedToEngine(registrar.context(), registrar.messenger())
      registrar.addActivityResultListener(plugin)
    }
  }

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    this.onAttachedToEngine(flutterPluginBinding.applicationContext, flutterPluginBinding.binaryMessenger)
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

  override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?): Boolean {
    OktaClient.getWebClient().handleActivityResult(requestCode, resultCode, data)
    return PendingOperation.hasPendingOperation != null
  }

  override fun onDetachedFromActivity() {
    this.mainActivity = null
  }

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    binding.addActivityResultListener(this)
    mainActivity = binding.activity
  }

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    binding.addActivityResultListener(this)
    mainActivity = binding.activity
  }

  override fun onDetachedFromActivityForConfigChanges() {
    this.mainActivity = null
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    PendingOperation.init(call.method, result)

    if (applicationContext == null)
      PendingOperation.error("Context not found","Context not found")

    try {
      when (call.method) {
        "initialize-okta" -> {
          createConfig(call.argument("config")as String?, applicationContext!!)
        }"sign-in" -> {
          signIn(this.mainActivity!!,"","")
        } "social-login" -> {
          signIn(this.mainActivity!!,call.argument("idp") as String?,call.argument("idp-scope") as String?)
        }"get-access-token"->{
          getAccessToken()
        }"logout"->{
          logout(this.mainActivity!!)
        }"get-user-profile"->{
          getUserProfile()
        }
        else -> {
          PendingOperation.error("Method not implemented", "Method called: $call.method")
        }
      }
    } catch (ex: java.lang.Exception) {
      PendingOperation.error("Okta oidc error", ex.localizedMessage)
    }
  }

  fun setActivity(activity: Activity) {
    this.mainActivity = activity
  }

  private fun onAttachedToEngine(context: Context, binaryMessenger: BinaryMessenger) {
    applicationContext = context
    channel = MethodChannel(binaryMessenger, "okta_oidc")
    channel.setMethodCallHandler(this)
  }
}