import UIKit

class APIDataService: APIDataServiceProtocol {
    
    private let api: ApiClientProtocol?
    
    private let emptyData = "data == nil"
    
    init(_ api: ApiClientProtocol?) {
        self.api = api
    }
    
    public func fetchGistsOfType(_ gistType: Int, pageToLoad: String?,_ completionHandler: @escaping (_ data: [Gist]?, _ url: String?) -> Void) {
        
        var urlToLoad: String?
        switch gistType {
        case GistTypes.Public.rawValue:
            urlToLoad = ApiUrls.getPublicGists()
        case GistTypes.Starred.rawValue:
            urlToLoad = ApiUrls.getStarredGists()
        case GistTypes.MyGists.rawValue:
            urlToLoad = ApiUrls.getMineGists()
        default:
            urlToLoad = ApiUrls.getPublicGists()
        }
        let url = pageToLoad != nil ? pageToLoad! : urlToLoad!
        fetchGists(gistType, url, completionHandler)
    }
    
   public func clearCache() {
        let cache = URLCache.shared
        cache.removeAllCachedResponses()
    }
    
    private func fetchGists(_ gistType: Int, _ url: String, _ completionHandler: @escaping (_ data: [Gist]?, _ url: String?) -> Void) {
        
        self.api!.performGet(gistType, url: url) { result, response, apiRequestError in
            guard apiRequestError == nil else {
                Notifications.postUnexpectedApiError(apiRequestError!)
                return
            }
            
            let gistArray = [Gist].deserialize(from: result)
            guard gistArray != nil else {
                Notifications.postViolation(sender: self, method: #function, violation: self.emptyData)
                return
            }
            
            var gists = [Gist]()
            gistArray?.forEach {
                if let gist = $0 {
                    gists.append(gist)
                }
            }
            
            let next = self.parseNextPageFromHeaders(response: response)
            completionHandler(gists, next)
        }
    }
    
    private func parseNextPageFromHeaders(response: HTTPURLResponse?) -> String? {
        guard let linkHeader = response?.allHeaderFields["Link"] as? String else {
            return nil
        }
        
        let components = linkHeader.split{ $0 == "," }.map{ String($0) }
        for item in components {
            let rangeOfNext = item.range(of: "rel=\"next\"")
            guard rangeOfNext != nil else {
                continue
            }
            
            let rangeOfPaddedURL = item.range(of: "<(.*)>;", options: .regularExpression,
                                              range: nil, locale: nil)
            guard let range = rangeOfPaddedURL else {
                return nil
            }
            
            let nextURL = item.substring(with: range).dropFirst().dropLast(2)
            return String(nextURL)
        }
        
        return nil
    }
}
