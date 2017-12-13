import Foundation

class ApiRequestError: Error, CustomStringConvertible {
    var isHttpError: Bool = false
    var statusCode: Int?
    var statusDetails: String?
    var responseBody: String?
    var sourceError: Error?
    var requestUrl: String?
    var requestMethod: String?
    var requestBody: String?
    
    public var description: String {
        var result = ""
        if isHttpError {
            result += "HTTP \(statusCode ?? 0) "
            
            if let body = self.responseBody {
                result += body
            }
        } else if let err = self.sourceError {
            
            if let nsError = err as? NSError {
                result = nsError.localizedDescription
            } else {
                result = "\(err)"
            }
        }
        
        return result
    }
    
    func getErrorInfoAsDict() -> [AnyHashable: Any]! {
        var result: [String: String] = [:] //
        
        if let url = self.requestUrl {
            result["HTTP-REQUEST-URL"] = url
        }
        if let method = self.requestMethod {
            result["HTTP-REQUEST-METHOD"] = method
        }
        if let requestContent = self.requestBody {
            result["HTTP-REQUEST-CONTENT"] = requestContent
        }
        
        if let statusCode = self.statusCode {
            result["HTTP-RESPONSE-STATUS"] = "\(statusCode)"
        }
        if let statusReason = self.statusDetails {
            result["HTTP-RESPONSE-STATUS-REASON"] = statusReason
        }
        if let body = self.responseBody {
            result["HTTP-RESPONSE-BODY"] = body
        }
        
        return result
    }
    
}

