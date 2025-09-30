package com.okta.okta_oidc.utils

import android.app.Activity
import com.okta.oidc.*
import com.okta.oidc.clients.sessions.SessionClient
import com.okta.oidc.clients.web.WebAuthClient
import com.okta.oidc.net.params.Prompt
import com.okta.oidc.net.response.UserInfo
import com.okta.oidc.util.AuthorizationException
import java.lang.Exception

object OktaClient {
    var isInitilized: Boolean = false
    private var config: OIDCConfig? = null
    private var webClient: WebAuthClient? = null

    fun init(config: OIDCConfig, webClient: WebAuthClient) {
        OktaClient.config = config
        OktaClient.webClient = webClient
        isInitilized = true
    }

    fun getConfig(): OIDCConfig {
        if (!isInitilized) {
            throw IllegalStateException("okta not initialized")
        }
        return config!!
    }

    fun getWebClient(): WebAuthClient {
        if (!isInitilized) {
            throw IllegalStateException("okta not initialized")
        }
        return webClient!!
    }
}

fun signIn(activity: Activity, idp: String?, idpScope: String?) {
    registerCallback(activity)
    OktaClient.getWebClient().signIn(activity, oktaPayLoad(idp, idpScope))
}
fun oktaPayLoad(idp: String?, idpScope: String?): AuthenticationPayload = AuthenticationPayload.Builder()
    .setIdp(idp?:"")
    .setIdpScope(idpScope?:"")
    .addParameter("prompt", Prompt.LOGIN)
    .build()

fun registerCallback(activity: Activity) {
    val sessionClient: SessionClient = OktaClient.getWebClient().sessionClient

    try{
        // Try to unregister callbacks loaded by signIn/signOut methods
        OktaClient.getWebClient().unregisterCallback()
    }catch(ex: Exception){}

    OktaClient.getWebClient().registerCallback(object :
        ResultCallback<AuthorizationStatus?, AuthorizationException?> {
        override fun onSuccess(status: AuthorizationStatus) {

            if (status == AuthorizationStatus.AUTHORIZED) {
                try {
                    val myMap: Map<String, Any> =
                        mapOf<String, Any>("status" to true, "message" to "Login success")
                    PendingOperation.success(myMap)

                } catch (e: AuthorizationException) {
                    //result[Constants.ERROR_CODE_KEY] = Errors.SIGN_IN_FAILED.errorCode
                    //result[Constants.ERROR_MSG_KEY] = Errors.SIGN_IN_FAILED.errorMessage

                    PendingOperation.error("Login failed", "Login failed")
                }
            } else if (status == AuthorizationStatus.SIGNED_OUT) {
                sessionClient.clear()
                //result[Constants.RESOLVE_TYPE_KEY] = Constants.SIGNED_OUT
                PendingOperation.success(true)
            } else {
                PendingOperation.error("Login failed", "Login failed")
            }
        }

        override fun onError(msg: String?, exception: AuthorizationException?) {
            if (exception != null) {
                PendingOperation.error(
                    "${exception.errorDescription}",
                    "${exception.errorDescription}"
                )
            }
        }

        override fun onCancel() {
            //  val result = mutableMapOf<Any, Any?>()
            // result[Constants.RESOLVE_TYPE_KEY] = Constants.CANCELLED
            PendingOperation.error("Canceled by user", "Canceled by user")
        }
    }, activity)
}

fun getAccessToken(){
    if (OktaClient.getWebClient().sessionClient.tokens.isAccessTokenExpired) {
        OktaClient.getWebClient().sessionClient.refreshToken(object :
            RequestCallback<Tokens, AuthorizationException> {
            override fun onSuccess(token: Tokens) {
                val responseMap: Map<String,Any> = mapOf<String, Any>("status" to true, "message" to token.accessToken!!)
                PendingOperation.success(responseMap)

            }

            override fun onError(error: String?, exception: AuthorizationException?) {
                if (exception != null) {
                    PendingOperation.error(
                        exception.errorDescription!!,
                        exception.errorDescription!!
                    )
                }else{
                    PendingOperation.error(
                        "error while refreshing token no description found",
                        "error while refreshing token no description found"
                    )
                }

            }
        })
    } else {
        val responseMap: Map<String,Any> = mapOf<String, Any>("status" to true, "message" to OktaClient.getWebClient().sessionClient.tokens.accessToken!!)
        PendingOperation.success(responseMap)
    }
}
fun logout(activity: Activity){
    OktaClient.getWebClient().signOut(activity, object : RequestCallback<Int, AuthorizationException> {
        override fun onSuccess(int: Int) {
            PendingOperation.success(true)
        }

        override fun onError(error: String?, exception: AuthorizationException?) {
            PendingOperation.error("Sign out failed", "Sign out failed")
        }
    })
}
fun getUserProfile(){


    OktaClient.getWebClient().sessionClient.getUserProfile(object : RequestCallback<UserInfo, AuthorizationException> {
            override fun onSuccess(result: UserInfo) {
                PendingOperation.success(result.toString())
            }

            override fun onError(error: String, exception: AuthorizationException) {
                PendingOperation.error(exception.errorDescription, exception.errorDescription)
            }
        })

}

fun isAuthenticated() {
    PendingOperation.success(OktaClient.getWebClient().sessionClient.isAuthenticated)
   }
