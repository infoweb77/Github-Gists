import Foundation
import Alamofire

class ApiClientMock: ApiClientProtocol {
    
    let mockMonitor: MockMonitor = MockMonitor("LocalStore")
    
    var callCompletionHandler: Bool = false
    var resultJson: String?
    var resultResponse: HTTPURLResponse?
    var error: ApiRequestError?
    var resultData: Data?
    
    init(json: String? = nil, data: Data? = nil, response: HTTPURLResponse? = nil, error: ApiRequestError? = nil) {
        self.resultJson = json
        self.resultData = data
        self.resultResponse = response
        self.error = error
        
        if self.resultData != nil || self.resultJson != nil || self.resultResponse != nil || self.error != nil {
            self.callCompletionHandler = true
        }
    }
    
    func performRequest(_ url: String, method: HTTPMethod, data: String?, completionHandler: @escaping ApiJSONCallback) {
        self.mockMonitor.registerCall("performRequest", args: ["url": url, "method": method, "data": data])
        if callCompletionHandler {
            completionHandler(resultJson, error)
        }
    }
    
    func performAuthRequest(_ url: String, params: Parameters, completionHandler: @escaping ApiJSONCallback) {
        self.mockMonitor.registerCall("performAuthRequest", args: ["url": url, "params": params])
        if callCompletionHandler {
            completionHandler(resultJson, error)
        }
    }
    
    func performGet(_ gistType: Int, url: String, completionHandler: @escaping ApiCallback) {
        self.mockMonitor.registerCall("performGet", args: ["url": url])
        if callCompletionHandler {
            completionHandler(resultJson, resultResponse, error)
        }
    }
    
    func performGet(_ gistType: Int, url: String, queryParams: Parameters?, completionHandler: @escaping ApiCallback) {
        self.mockMonitor.registerCall("performGet", args: ["url": url, "queryParams": queryParams])
        if callCompletionHandler {
            completionHandler(resultJson, resultResponse, error)
        }
    }
    
    func performGetData(_ url: String, completionHandler: @escaping ApiDataCallback) {
        self.mockMonitor.registerCall("performGetData", args: ["url": url])
        if callCompletionHandler {
            completionHandler(resultData, error)
        }
    }
    
    func performGetData(_ url: String, queryParams: Parameters?, completionHandler: @escaping ApiDataCallback) {
        self.mockMonitor.registerCall("performGetData", args: ["url": url, "queryParams": queryParams])
        if callCompletionHandler {
            completionHandler(resultData, error)
        }
    }
}

