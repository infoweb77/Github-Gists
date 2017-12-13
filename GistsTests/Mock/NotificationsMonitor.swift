import Foundation

class NotificationsMonitor: NSObject {
    override init() {
        super.init()
        
        self.observe(Notifications.AuthRequired, with: #selector(self.onAuthenticationRequired))
        self.observe(Notifications.UnexpectedApiError, with: #selector(self.onUnexpectedApiError))
        self.observe(Notifications.GuardViolation, with: #selector(self.onGuardViolation))
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    var authenticationRequiredFired: Bool = false
    var unexpectedApiError: Bool = false
    var guardViolation: Bool = false
    
    func onAuthenticationRequired(notification: Notification) {
        authenticationRequiredFired = true
    }
    
    func onUnexpectedApiError(notification: Notification) {
        unexpectedApiError = true
    }
    
    func onGuardViolation(notification: Notification) {
        guardViolation = true
    }
    
    var hasAnyNotifications: Bool {
        return self.authenticationRequiredFired ||
            self.unexpectedApiError ||
            self.guardViolation
    }
}
