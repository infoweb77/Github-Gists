import Foundation

class MockMonitor {
    
    public let name: String
    
    init(_ name: String) {
        self.name = name
    }
    
    public func registerCall(_ methodName: String, args: [String: Any?]) {
        
        var unexpected = true
        for expectation in self.expectations {
            if expectation.tryRegisterCall(methodName, args) {
                unexpected = false
                break
            }
        }
        self.registeredCalls.append(MockMonitor.CallRecord(methodName, args: args, unexpected: unexpected))
    }
    
    public func expectCall(of methodName: String, withCheck validator: ArgsValidator? = nil) {
        self.expectations.append(CallExpectation(methodName, validator))
    }
    
    public func verifyAll() -> [String] {
        var result: [String] = []
        
        let uncalledExpectations = self.expectations.filter { exp in !exp.callRegistered }
        for exp in uncalledExpectations {
            result.append(exp.description)
        }
        
        let calledUnexpectedly = self.registeredCalls.filter { record in record.unexpected }
        for call in calledUnexpectedly {
            result.append(call.description)
        }
        return result
    }
    
    public func getArgsFor(callOf method: String) -> [String: Any?]? {
        let call = self.registeredCalls.first { record in record.methodName == method }
        guard call != nil else {
            return nil
        }
        return call!.args
    }
    
    typealias ArgsValidator = (_ args: [String: Any?]) -> Bool
    
    var expectations: [CallExpectation] = []
    var registeredCalls: [CallRecord] = []
    
    class CallExpectation: CustomStringConvertible, CustomDebugStringConvertible {
        
        var methodName: String = ""
        var argsValidation: ArgsValidator?
        var callRegistered: Bool = false
        
        init(_ method: String, _ validation: ArgsValidator? = nil) {
            self.methodName = method
            self.argsValidation = validation
        }
        
        public var debugDescription: String {
            return description
        }
        
        public var description: String {
            if self.callRegistered {
                return "\(methodName)()"
            } else {
                return "'\(methodName)' was not called"
            }
        }
        
        func tryRegisterCall(_ method: String, _ args: [String: Any?]) -> Bool {
            guard self.callRegistered == false else {
                return false
            }
            
            guard self.methodName == method else {
                return false
            }
            
            if let validation = self.argsValidation {
                if validation(args) {
                    self.callRegistered = true
                    return true
                }
            } else {
                self.callRegistered = true
                return true
            }
            
            return false
        }
    }
    
    class CallRecord: CustomStringConvertible, CustomDebugStringConvertible {
        
        var methodName: String = ""
        var args: [String: Any?]?
        let unexpected: Bool
        
        init(_ methodName: String, args: [String: Any?]? = nil, unexpected: Bool = false) {
            self.methodName = methodName
            self.unexpected = unexpected
            self.args = args
        }
        
        public var debugDescription: String {
            return description
        }
        
        public var description: String {
            if self.unexpected {
                return "\(methodName)(\(self.argsDescription) was called unexpectedly"
            } else {
                return "\(methodName)(\(self.argsDescription)"
            }
        }
        
        private var argsDescription: String {
            if args == nil || args!.count == 0 {
                return ""
            }
            let nilString = "nil"
            return self.args!.map { element in "\(element.key):\(element.value ?? nilString)" }.joined(separator: ", ")
        }
    }
}

