import Foundation
struct OktaConfigModel{
    var client_id : String = ""
    var redirect_uri : String = ""
    var end_session_redirect_uri : String = ""
    var discovery_uri : String = ""
    var scopes : [String] = []

    init() {}

    init(response : [String : Any]) {

        if let client_id = response["client_id"] as? String {
            self.client_id = client_id
        }

        if let redirect_uri = response["redirect_uri"] as? String {
            self.redirect_uri = redirect_uri
        }

        if let end_session_redirect_uri = response["end_session_redirect_uri"] as? String {
            self.end_session_redirect_uri = end_session_redirect_uri
        }

        if let discovery_uri = response["discovery_uri"] as? String {
            self.discovery_uri = discovery_uri
        }
        if let scopes = response["scopes"] as? [String] {
            for item in scopes{
                self.scopes.append(item as String)
            }
        }

    }
}

extension String {
    func toJSON() -> Any? {
        guard let data = self.data(using: .utf8, allowLossyConversion: false) else { return nil }
        return try? JSONSerialization.jsonObject(with: data, options: .mutableContainers)
    }
}