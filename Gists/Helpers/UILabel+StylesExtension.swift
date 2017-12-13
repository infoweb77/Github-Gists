import UIKit

typealias LabelStyle = ((_ label: UILabel) -> Void)

extension UILabel {
    public func setStyle(weight: CGFloat, fontSize size: CGFloat, textColor color: UIColor, textAligment align: NSTextAlignment = .left) {
        let font = UIFont.systemFont(ofSize: size, weight: weight)
        self.numberOfLines = 0
        self.adjustsFontSizeToFitWidth = false
        self.textColor = color
        self.font = font
        self.textAlignment = align
    }

    func apply(style: LabelStyle) {
        style(self)
    }
}
