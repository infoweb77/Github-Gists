import UIKit

class ASColor: NSObject {
    class var lightGrey: UIColor { return UIColor(hexValue: 0xEBE5D9) }
    class var battleshipGrey: UIColor { return UIColor(hexValue: 0x75797d) }
    class var gray: UIColor { return UIColor(hexValue: 0x9B9B9B) }
    class var darkGray: UIColor { return UIColor(hexValue: 0x2C2D30) }
    class var darkGray2: UIColor { return UIColor(hexValue: 0x1c1d1e) }
    class var greyish: UIColor {return UIColor(hexValue: 0xb2b2b2)}
    class var paleGray: UIColor { return UIColor(hexValue: 0xF0F1F3) }
    class var warmGray: UIColor { return UIColor(hexValue: 0x9B9B9B) }
    class var silver: UIColor { return UIColor(hexValue: 0xc7c7cc) }

    class var tomato: UIColor { return UIColor(hexValue: 0xF06523) }
    class var scarlet: UIColor { return UIColor(hexValue: 0xD0011B) }
    class var reddishPink: UIColor { return UIColor(hexValue: 0xfc3262) }
    class var redPink: UIColor { return UIColor(hexValue: 0xF93665) }
    class var rouge: UIColor { return UIColor(hexValue: 0xA41C3C) }

    class var lightTeal: UIColor { return UIColor(hexValue: 0x77CDE5) }
    class var clearBlue: UIColor { return UIColor(hexValue: 0x278BF7) }
    class var turquoise: UIColor { return UIColor(hexValue: 0x0ac9b3) }
    class var tealish: UIColor { return UIColor(hexValue: 0x24c8b3) }
    class var blueGreen: UIColor { return UIColor(hexValue: 0x159488) }
    class var gunmetal: UIColor { return UIColor(hexValue: 0x4C4F5A) }

    class var lightGold: UIColor { return UIColor(hexValue: 0xffcb57) }
    class var orange: UIColor { return UIColor.orange }
    class var black: UIColor { return UIColor.black }
    class var white: UIColor { return UIColor.white }
    class var clear: UIColor { return UIColor.clear }

    class func colorWhiteWithAlpha(alpha: CGFloat) -> UIColor { return UIColor.white.withAlphaComponent(alpha) }
}
