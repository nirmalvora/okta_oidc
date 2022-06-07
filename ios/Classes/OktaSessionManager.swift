import Foundation
import OktaOidc
class OktaSessionManager {
    
    // Used for setting up the oidc instance with config object
    var oktaOidc : OktaOidc?
    // Used to store the session info - access, refresh, id tokens
    var stateManager : OktaOidcStateManager?
    var name : String = ""
    var email : String = ""
    /// Checks if tokens are expired
    var tokensExpired : Bool {
        if let state = stateManager {
            if let _ = state.accessToken {
                return false
            }
            return true
        }
        return true
    }
    
    // Shared singleton instance
    public init(oktaConfigModel:OktaConfigModel) {
        
        do {
            let configDict = [
                "issuer": oktaConfigModel.discovery_uri,
                "clientId": oktaConfigModel.client_id,
                "redirectUri": oktaConfigModel.redirect_uri,
                "logoutRedirectUri": oktaConfigModel.end_session_redirect_uri,
                "scopes": oktaConfigModel.scopes.joined(separator: " ")
            ]
            print(configDict)
            // Setup the configuration from the ConfigDictionary
            let config = try OktaOidcConfig(with: configDict)
            config.noSSO = true
            oktaOidc = try OktaOidc(configuration: config)
            
            // If the tokens already exists, save the StateManager state and read the tokens
            self.stateManager = OktaOidcStateManager.readFromSecureStorage(for: oktaOidc!.configuration)
            self.printTokens()
            
            // If the stateManager is nil OR the IsUserLoggedIn field is false, Logout the user
            //
            if stateManager == nil  {
                // If Logged In Status is false
                // Remove the Keychain entry
                self.revokeTokens(success: {}, failure: {})
                
                
            } else {
                // User Session is Active. Allow the User to Proceed
                //
                
            }
            
        } catch let err {
            print(err)
        }
    }
    
    func oktaLogin(params: [String:String],viewController: UIViewController,success : @escaping (LoginResponse) -> Void, failure :@escaping (FlutterError) -> Void) {
        
        guard let okta = self.oktaOidc else {
        let flutterError: FlutterError = FlutterError(code: "OktaLogin_Error", message:  "Login fail", details: "Login fail")
            failure(flutterError)
            print("Cannot instantiate Okta object from given configuration")
            return
        }
        
        
        okta.signInWithBrowser(from: viewController,additionalParameters: params,callback: { oidcStateManager, error in
            
            guard error == nil else {
               let flutterError: FlutterError = FlutterError(code: "OktaLogin_Error", message:  (error! as! OktaOidcError).errorDescription!, details: (error! as! OktaOidcError).errorDescription!)
                failure(flutterError)
                return
            }
            
            self.stateManager = oidcStateManager
            
            self.stateManager?.writeToSecureStorage()
            
            self.printTokens()
            success(LoginResponse(status: true,message: "Login Success"))
            
        })
    }
    
    
    
    func signOutFromBrowser(viewController: UIViewController,success : @escaping () -> Void, failure : @escaping () -> Void) {
        guard let okta = self.oktaOidc else {
            failure()
            print("Cannot instantiate Okta object from given configuration")
            return
        }
        
        okta.signOutOfOkta(self.stateManager!, from: viewController) { (error) in
            guard error == nil else {
                print(error ?? "cannot parse error")
                failure()
                return
            }
            success()
            print("Signed out")
        }
    }
    
    //MARK:- Manage Tokens
    /// Removes the Tokens from the keychain and resets the session
    /// Handles the User logged in status
    func revokeTokens(success :@escaping () -> Void, failure : @escaping () -> Void) {
        print("In Revoke Tokens")
        
        do {
            if(self.stateManager != nil){
                self.stateManager?.clear()
                self.stateManager?.revoke(stateManager?.accessToken ?? nil, callback: { (done, error) in
                    
                    self.stateManager?.clear()
                    self.stateManager = nil
                    
                    
                    print("Okta State Manager cleared")
                    
                    if error != nil {
                        success()
                        print(error ?? "Error in Revoking tokens **")
                    }
                    success()
                })
            }else{
                success()
            }
        } catch let err {
            success()
        }
    }
    
    /// Refreshes the accessToken
    func renewTokens(success : @escaping () -> Void, failure :@escaping (String)  -> Void) {
        
        print("In Renew Tokens")
        if stateManager == nil {
            print("StateManager not initialised")
            failure("error while refreshing token state manager not initialize")
            return
        }
        if let accessToken = stateManager?.accessToken {
            // use access token
            print(accessToken)
            success()
            
        } else {
            
            self.stateManager?.renew(callback: { (oidcStateManager, error) in
                
                guard error == nil else {
                    print("Error in refreshing the tokens")
                    print(error ?? "Cannot parse error")
                    failure(error?.localizedDescription ?? "error while refreshing token")
                    return
                }
                
                self.stateManager = oidcStateManager
                self.printTokens()
                //
                // Write tokens to secure storage
                //
                self.stateManager?.writeToSecureStorage()
                success()
            })
        }
    }
    
    
    func getUser(callback: @escaping ((String?, FlutterError?)-> (Void))) {
        if stateManager != nil {
            stateManager?.getUser { response, error in
                guard let response = response else {
                    let flutterError: FlutterError = FlutterError(code: "GetUser_Error", message: error?.localizedDescription, details: error.debugDescription)
                    callback(nil, flutterError)
                    return
                }
                if let jsonData = try? JSONSerialization.data(withJSONObject: response, options: .prettyPrinted) {
                    let jsonString = String(data: jsonData, encoding: .ascii)
                    callback(jsonString, nil)
                } else {
                    let flutterError: FlutterError = FlutterError(code: "GetUser_Error", message: error?.localizedDescription, details: error.debugDescription)
                    
                    callback(nil, flutterError)
                }
            }
        }else{
            let flutterError: FlutterError = FlutterError(code: "GetUser_Error", message: "User not logged in", details: "User not logged in")
            callback(nil, flutterError)
        }
    }
    
    func printTokens() {
        guard let state = self.stateManager else {
            print("State manager found null while printing tokens")
            return
        }
        print("AT : \(state.accessToken ?? "NA")\n")
        print("RT : \(state.refreshToken ?? "NA")\n")
        print("IDT : \(state.idToken ?? "NA")\n")
    }
}

