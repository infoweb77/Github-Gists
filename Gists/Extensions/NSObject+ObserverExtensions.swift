import Foundation

extension NSObject {
    func observe(_ notification: NSNotification.Name, with selector: Selector) {
        NotificationCenter.default.addObserver(self,
                selector: selector,
                name: notification,
                object: nil)
    }
}
