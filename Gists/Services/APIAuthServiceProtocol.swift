import Foundation

protocol APIAuthServiceProtocol {
    
    var authToken:String? { set get }
    
    func hasTokeh() -> Bool
    func URLToStartOAuth2Login() -> URL?
    func processOAuthStep1Response(_ url: URL)
}
