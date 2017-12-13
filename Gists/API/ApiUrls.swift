import Foundation
import Alamofire

class ApiUrls {
    
    static var apiBaseUrl: String = "https://api.github.com"
    static var authBaseUrl: String = "https://github.com/login/oauth"
    
    public static func setBaseUrls(apiServiceUrl: String, oauthServiceUrl: String) {
        apiBaseUrl = apiServiceUrl
        authBaseUrl = oauthServiceUrl
    }
    
    public static func getAuthorizeUrl() -> String {
        return "\(authBaseUrl)/authorize"
    }
    
    public static func getAuthTokenUrl() -> String {
        return "\(authBaseUrl)/access_token"
    }
    
    public static func getPublicGists() -> String {
        return "\(apiBaseUrl)/gists/public"
    }
    
    public static func getStarredGists() -> String {
        return "\(apiBaseUrl)/gists/starred"
    }
    
    public static func getMineGists() -> String {
        return "\(apiBaseUrl)/gists"
    }
    
    public static func isStarredGists(_ id: String) -> String {
        return "\(apiBaseUrl)/gists/\(id)/star"
    }
}

