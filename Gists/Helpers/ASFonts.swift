import UIKit

class ASFonts: NSObject {
    
    static let regular =    UIKit.UIFontWeightRegular
    static let light =      UIKit.UIFontWeightLight
    static let semibold =   UIKit.UIFontWeightSemibold
    static let bold =       UIKit.UIFontWeightBold
    static let heavy =      UIKit.UIFontWeightHeavy
    
    class func fontRegular(size: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: size, weight: regular)
    }
    
    class func fontLight(size: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: size, weight: light)
    }
    
    class func fontSemibold(size: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: size, weight: semibold)
    }
    
    class func fontBold(size: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: size, weight: bold)
    }
    
    class func fontHeavy(size: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: size, weight: heavy)
    }
}
