import Foundation

protocol EmpType {
    var isEmpty: Bool { get }
}
extension String: EmpType { }
extension Optional where Wrapped: EmpType {
    var isNilOrEmpty: Bool {
        return self?.isEmpty ?? true
    }
}
