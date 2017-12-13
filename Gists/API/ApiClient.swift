import Foundation
import Alamofire

class ApiClient: ApiClientProtocol {
    
    public func performRequest(_ url: String,
                               method: HTTPMethod,
                               data: String? = nil,
                               completionHandler: @escaping ApiJSONCallback) {
        Notifications.postNetworkActivityStarted(method, url, data: data)
        
        var params: Parameters = Parameters()
        if data != nil {
            params["body"] = data
        }
        
        let headers: HTTPHeaders? = nil
            
        Alamofire.request(url, method: method, parameters: params, encoding: JSONEncoding.default, headers: headers)
            .validate()
            .responseJSON(completionHandler: self.buildJSONCompletionHandler(completionHandler))
    }
    
    public func performAuthRequest(_ url: String,
                               params: Parameters,
                               completionHandler: @escaping ApiJSONCallback) {
        Notifications.postNetworkActivityStarted(.post, url, data: "auth")
        
        let header = ["Accept": "application/json"]
        
        Alamofire.request(url, method: .post, parameters: params,
                          encoding: URLEncoding.default, headers: header)
            .validate()
            .responseJSON(completionHandler: self.buildJSONCompletionHandler(completionHandler))
    }
    
    func buildHeaders() -> HTTPHeaders? {
        let authService = ObjectFactory.get(type: APIAuthServiceProtocol.self)
        let authToken = authService?.authToken
        
        if let token = authToken {
            return [ "Authorization": "token \(token)" ]
        }
        return nil
    }
    
    // main
    public func performGet(_ gistType: Int, url: String, queryParams: Parameters?,
                            completionHandler: @escaping ApiCallback) {
        
        Notifications.postNetworkActivityStarted(.get, url, params: queryParams)
        
        let headers: HTTPHeaders? = gistType == 0 ? nil : buildHeaders()
        
        Alamofire.request(url, parameters: queryParams, encoding: JSONEncoding.default, headers: headers)
            .validate()
            .responseString(completionHandler: self.buildCompletionHandler(completionHandler))
        
    }
    
    public func performGet(_ gistType: Int, url: String,
                            completionHandler: @escaping ApiCallback) {
        
        performGet(gistType, url: url, queryParams: nil, completionHandler: completionHandler)
    }
    
    // data
    public func performGetData(_ url: String,
                               queryParams: Parameters?,
                               completionHandler: @escaping ApiDataCallback) {
        
        Notifications.postNetworkActivityStarted(.get, url, params: queryParams)
        
        let headers: HTTPHeaders? = nil // token
            
        Alamofire.request(url, parameters: queryParams, encoding: JSONEncoding.default, headers: headers)
            .validate()
            .responseData(completionHandler: self.buildDataCompletionHandler(completionHandler))
    }
    
    func performGetData(_ url: String,
                        completionHandler: @escaping ApiDataCallback) {
        performGetData(url, queryParams: nil, completionHandler: completionHandler)
    }
    
    private func buildCompletionHandler(_ completionHandler: @escaping (_ dataResult: String?, _ response: HTTPURLResponse?, _ error: ApiRequestError?) -> Void) -> ((DataResponse<String>) -> Void) {
            
            func onRequestComplete(_ dataResponse: DataResponse<String>) {
                
                switch dataResponse.result {
                case .success(let value):
                    Notifications.postNetworkActivityComplete(result: dataResponse.result)
                    let response = dataResponse.response
                    completionHandler(value, response, nil)
                    return
                case .failure(let error):
                    if let response = dataResponse.response {
                        
                        let apiErr = self.buildError(error: error, dataResponse: dataResponse)
                        Notifications.postNetworkActivityComplete(result: dataResponse.result, apiError: apiErr)
                        
                        let status = response.statusCode
                        guard status != 401 && status != 403 else {
                            Notifications.postAuthRequired()
                            return
                        }
                        
                        completionHandler(nil, nil, apiErr)
                    } else {
                        Notifications.postNetworkActivityComplete(result: dataResponse.result)
                    }
                    return
                }
            }
            
            return onRequestComplete
    }
    
    private func buildJSONCompletionHandler(_ completionHandler: @escaping (_ dataResult: Any?, _ error: ApiRequestError?) -> Void) -> ((DataResponse<Any>) -> Void) {
        
        func onRequestComplete(_ dataResponse: DataResponse<Any>) {
            
            switch dataResponse.result {
            case .success(let value):
                Notifications.postNetworkActivityComplete(result: dataResponse.result)
                completionHandler(value, nil)
                return
            case .failure(let error):
                if let response = dataResponse.response {
                    
                    let apiErr = self.buildError(error: error, dataResponse: dataResponse)
                    Notifications.postNetworkActivityComplete(result: dataResponse.result, apiError: apiErr)
                    
                    let status = response.statusCode
                    guard status != 401 && status != 403 else {
                        Notifications.postAuthRequired()
                        return
                    }
                    
                    completionHandler(nil, apiErr)
                } else {
                    Notifications.postNetworkActivityComplete(result: dataResponse.result)
                }
                return
            }
        }
        
        return onRequestComplete
    }
    
    private func buildDataCompletionHandler(_ completionHandler: @escaping (_ dataResult: Data?, _ error: ApiRequestError?) -> Void)
        -> ((DataResponse<Data>) -> Void) {
            
            func onRequestComplete(_ dataResponse: DataResponse<Data>) {
                
                switch dataResponse.result {
                case .success(let value):
                    Notifications.postNetworkActivityComplete(result: dataResponse.result)
                    completionHandler(value, nil)
                    return
                case .failure(let error):
                    
                    if let response = dataResponse.response {
                        
                        let apiErr = self.buildError(error: error, dataResponse: dataResponse)
                        Notifications.postNetworkActivityComplete(result: dataResponse.result, apiError: apiErr)
                        
                        let status = response.statusCode
                        guard status != 401 && status != 403 else {
                            Notifications.postAuthRequired()
                            return
                        }
                        
                        completionHandler(nil, apiErr)
                    } else {
                        Notifications.postNetworkActivityComplete(result: dataResponse.result)
                    }
                    return
                }
            }
            
            return onRequestComplete
    }
    
    private func buildError<T>(error: Error?, dataResponse: DataResponse<T>) -> ApiRequestError? {
        if let response = dataResponse.response {
            let status = response.statusCode
            
            let err = ApiRequestError()
            err.isHttpError = true
            err.sourceError = error
            err.statusCode = status
            
            if let responseBytes = dataResponse.data {
                err.responseBody = String(data: responseBytes, encoding: .utf8)
            }
            
            if let request = dataResponse.request {
                err.requestUrl = request.url!.absoluteString
                
                if let requestBytes = request.httpBody {
                    err.requestBody = String(data: requestBytes, encoding: .utf8)
                }
                
                err.requestMethod = request.httpMethod
            }
            
            return err
        }
        
        return nil
    }
    
}

