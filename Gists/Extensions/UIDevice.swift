import UIKit

public extension UIDevice {
    
    public var isIpad: Bool {
        if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad {
            return true
        } else {
            return false
        }
    }
    
    public var isIphone4OrLess: Bool {
        let screenSize = UIScreen.main.bounds.size
        
        let height = max(screenSize.width, screenSize.height)
        
        if height < 568.0 {
            return true
        }
        return false
    }
    
    public var isIphone5OrIpodTouch: Bool {
        let screenSize = UIScreen.main.bounds.size
        
        let height = max(screenSize.width, screenSize.height)
        
        if height == 568.0 {
            return true
        }
        return false
    }
    
    public var isIphone6: Bool {
        let screenSize = UIScreen.main.bounds.size
        
        let height = max(screenSize.width, screenSize.height)
        
        if height == 667.0 {
            return true
        }
        return false
    }
    
    public var isIphone6OrNewer: Bool {
        let screenSize = UIScreen.main.bounds.size
        
        let height = max(screenSize.width, screenSize.height)
        
        if height >= 667.0 {
            return true
        }
        return false
    }
    
    public var isIphone6P: Bool {
        let screenSize = UIScreen.main.bounds.size
        
        let height = max(screenSize.width, screenSize.height)
        
        if height == 736.0 {
            return true
        }
        return false
    }
    
}
