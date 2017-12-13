import Foundation
import Alamofire

typealias ApiDataCallback = (_ result: Data?, _ error: ApiRequestError?) -> Void
typealias ApiJSONCallback = (_ result: Any?, _ error: ApiRequestError?) -> Void
typealias ApiCallback = (_ result: String?, _ response: HTTPURLResponse?, _ error: ApiRequestError?) -> Void


protocol ApiClientProtocol {
    func performRequest(_ url: String,
                        method: HTTPMethod,
                        data: String?,
                        completionHandler: @escaping ApiJSONCallback)
    
    func performAuthRequest(_ url: String,
                            params: Parameters,
                            completionHandler: @escaping ApiJSONCallback)
    
    func performGet(_ gistType: Int,
                    url: String,
                    completionHandler: @escaping ApiCallback)
    
    func performGet(_ gistType: Int,
                    url: String,
                    queryParams: Parameters?,
                    completionHandler: @escaping ApiCallback)
    
    func performGetData(_ url: String,
                        queryParams: Parameters?,
                        completionHandler: @escaping ApiDataCallback)
    
    func performGetData(_ url: String,
                        completionHandler: @escaping ApiDataCallback)
}

