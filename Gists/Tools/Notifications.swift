import Foundation
import Alamofire

class Notifications {
    public static let GuardViolation = Notification.Name("GUARD_VIOLATION")
    public static let AuthRequired = Notification.Name("AUTHENTICATION_REQUIRED")
    public static let UnexpectedApiError = Notification.Name("UNEXPECTED_API_ERROR")
    public static let UnexpectedError = Notification.Name("UNEXPECTED_ERROR")
    public static let NetworkActivityStarted = Notification.Name("NETWORK_ACTIVITY_STARTED")
    public static let NetworkActivityComplete = Notification.Name("NETWORK_ACTIVITY_COMPLETE")
    
    public static func postAuthRequired() {
        print("AUTH_REQUESTED")
        NotificationCenter.default.post(Notification(name: AuthRequired))
    }
    
    public static func postUnexpectedApiError(_ error: ApiRequestError) {
        print("API_ERROR", error)
        NotificationCenter.default.post(
            Notification(name: UnexpectedApiError, userInfo: ["api_error": error]))
    }
    
    public static func postUnexpectedError(err: Error, msg: String) {
        print("UNEXPECTED_ERROR", err, msg)
        NotificationCenter.default.post(
            Notification(name: UnexpectedError, userInfo: ["error": err, "message": msg]))
    }
    
    /** Use this to notify about some unexpected arguments.
     EX: guard someArg != nil else {
     Notifications.postGuardViolation(sender: self, method: "doSomething", violation: "someArg != nil"
     ...
     }
     
     */
    public static func postViolation(sender: Any?, method: String, violation: String) {
        print("GUARD_VIOLATION", sender ?? "unknown sender", method, violation)
        
        var args: [String: Any] = [
            "method": method,
            "violation": violation
        ]
        
        if let sender = sender {
            let mirror = Mirror(reflecting: sender)
            args["sender"] = mirror.subjectType
        }
        
        NotificationCenter.default.post(Notification(name: GuardViolation, userInfo: args))
    }
    
    public static func postNetworkActivityStarted(_ method: HTTPMethod, _ url: String, data: String? = nil,
                                                  params: Parameters? = nil, headers: HTTPHeaders? = nil) {
        var args: [String: Any] = [
            "method": method,
            "url": url
        ]
        
        if let data = data {
            args["data"] = data
        }
        if let params = params {
            args["params"] = params
        }
        if let headers = headers {
            args["headers"] = headers
        }
        NotificationCenter.default.post(Notification(name: NetworkActivityStarted, userInfo: args))
    }
    
    public static func postNetworkActivityComplete<Value>(result: Result<Value>, apiError: ApiRequestError? = nil,
                                                          response: HTTPURLResponse? = nil) {
        var args: [String: Any] = [
            "result": result
        ]
        
        if let apiError = apiError {
            args["apiError"] = apiError
        }
        
        if let response = response {
            args["response"] = response
        }
        
        NotificationCenter.default.post(Notification(name: NetworkActivityComplete, userInfo: args))
    }
}

