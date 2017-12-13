import Foundation
import Locksmith

class APIAuthService: APIAuthServiceProtocol {
    
    private let clientID: String = "2b2b97b41f153d373cf2"
    private let clientSecret: String = "3fd76a110de32b5d43d136d83e2145bcd4b8f288"
    
    private let api: ApiClientProtocol?
    
    private let emptyData = "data == nil"
    
    var authToken:String? {
        set {
            guard let newValue = newValue else {
                let _ = try? Locksmith.deleteDataForUserAccount(userAccount: "github")
                return
            }
            
            guard let _ = try? Locksmith.updateData(data: ["token": newValue], forUserAccount: "github") else {
                let _ = try? Locksmith.deleteDataForUserAccount(userAccount: "github")
                return
            }
        }
        get {
            let dictionary = Locksmith.loadDataForUserAccount(userAccount: "github")
            return dictionary?["token"] as? String
        }
    }
    
    init(_ api: ApiClientProtocol?) {
        self.api = api
    }
    
    public func hasTokeh() -> Bool {
        if let token = authToken {
            return !token.isEmpty
        }
        return false
    }
    
    public func URLToStartOAuth2Login() -> URL? {
        let authPath: String = ApiUrls.getAuthorizeUrl() + "?client_id=\(clientID)&scope=gist&state=TEST_STATE"
        return URL(string: authPath)
    }
    
    func processOAuthStep1Response(_ url: URL) {
        guard let code = extractCodeFromResponse(url) else {
            return
        }
        
        let url = ApiUrls.getAuthTokenUrl()
        let tokenParams = ["client_id": clientID, "client_secret": clientSecret, "code": code]
        
        api?.performAuthRequest(url, params: tokenParams) { jsonResult, apiRequestError in
            guard apiRequestError == nil else {
                Notifications.postUnexpectedApiError(apiRequestError!)
                return
            }
            guard let json = jsonResult as? [String: String] else {
                Notifications.postViolation(sender: self, method: #function, violation: self.emptyData)
                return
            }
            self.authToken = self.parseOAuthTokenResponse(json)
        }
    }
    
    private func extractCodeFromResponse(_ url: URL) -> String? {
        let components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        var code: String?
        
        guard let queryItems = components?.queryItems else {
            return nil
        }
        code = queryItems.first(where: { $0.name.lowercased() == "code" })?.value
        return code
    }

    private func parseOAuthTokenResponse(_ json: [String: String]) -> String? {
        var token: String?
        for (key, value) in json {
            switch key {
            case "access_token":
                token = value
            default:
                print(" -> key = \(key)")
            }
        }
        return token
    }
}
