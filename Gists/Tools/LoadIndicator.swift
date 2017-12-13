import Foundation

import Foundation
import SVProgressHUD

class LoadIndicator: NSObject {
    
    var showTimeout = 0 // 500
    var hideTimeout = 0 // 400
    var runningActivities = 0
    
    private let lockQueue = DispatchQueue(label: "loadIndicator")
    
    override init() {
        super.init()
        
        // subscribe on notifications
        self.observe(Notifications.NetworkActivityStarted, with: #selector(onNetworkActivityStarted))
        self.observe(Notifications.NetworkActivityComplete, with: #selector(onNetworkActivityComplete))
        self.observe(Notifications.AuthRequired, with: #selector(onAppResetToLoginScreen))
    }
    
    public func onNetworkActivityStarted(notification: Notification) {
        self.incrementActivity()
    }
    
    public func onNetworkActivityComplete(notification: Notification) {
        self.decrementActivity()
    }
    
    public func onAppResetToLoginScreen(notification: Notification) {
        self.lockQueue.sync {
            runningActivities = 0
        }
        SVProgressHUD.dismiss()
    }
    
    public static let mainInstance = LoadIndicator()
    
    public func decrementActivity() {
        self.lockQueue.sync {
            runningActivities -= 1
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(self.hideTimeout)) {
            self.lockQueue.sync {
                if self.runningActivities <= 0 {
                    self.runningActivities = 0
                    SVProgressHUD.dismiss()
                }
            }
        }
    }
    
    public func incrementActivity() {
        self.lockQueue.sync {
            runningActivities += 1
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(self.showTimeout)) {
            self.lockQueue.sync {
                if self.runningActivities > 0 {
                    SVProgressHUD.show()
                }
            }
        }
    }
}
