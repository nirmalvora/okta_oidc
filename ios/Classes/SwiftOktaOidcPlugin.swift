import Flutter
import UIKit
import OktaOidc
public class SwiftOktaOidcPlugin: NSObject, FlutterPlugin {
    var oktaSessionManager: OktaSessionManager?
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "okta_oidc", binaryMessenger: registrar.messenger())
        let instance = SwiftOktaOidcPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if(call.method == "initialize-okta")
        {
            guard let oktaInfo: Dictionary = call.arguments as? [String: Any?] else {
                result(false);
                return;
            }
            let oktaConfig = OktaConfigModel(response: (( oktaInfo["config"]!! as! String).toJSON()as! [String:Any]))
            oktaSessionManager = OktaSessionManager(oktaConfigModel:oktaConfig)
            result(true)
        }else if(call.method == "sign-in")
        {
            var  viewController: UIViewController =
            (UIApplication.shared.delegate?.window??.rootViewController)!;
            oktaSessionManager!.oktaLogin(params: [:], viewController: viewController,  success: {(response) in
                result(["status":response.status,"message":response.message])
            }, failure: {(response) in
                result(response)
            })
        }else if(call.method == "social-login") {
            var  viewController: UIViewController =
                       (UIApplication.shared.delegate?.window??.rootViewController)!;
            guard let oktaInfo: Dictionary = call.arguments as? [String: Any?] else {

                 let flutterError: FlutterError = FlutterError(code: "OktaLogin_Error", message:  "Please provide idp for social login", details: "Please provide idp for social login")
                result(flutterError);
                return;
            }
            oktaSessionManager!.oktaLogin(params: ["idp":oktaInfo["idp"]!! as! String], viewController: viewController, success: {(response) in
                result(["status":response.status,"message":response.message])
            }, failure: {(response) in
                result(response)
            })
        }
        else if(call.method == "get-access-token") {
            oktaSessionManager!.renewTokens {
                result(["status":true,"message":self.oktaSessionManager!.stateManager?.accessToken ?? ""])
            } failure: {(response) in
                result(["status":false,"message":response])
            }
        }
        else if(call.method == "logout") {
            oktaSessionManager!.revokeTokens(success: {
                result(true)
            }, failure: {
                result(false)
            })
        }  else if(call.method == "get-user-profile") {
             oktaSessionManager!.getUser(callback: { user, error in
               if(error != nil) {
                 result(error)
                 return
               }
               result(user);
             })
        }
        else {
            result(FlutterMethodNotImplemented)
        }
    }
}
