import UIKit

typealias TextFieldStyle = ((_ textField: UITextField) -> Void)

extension UITextField {
    func setBottomBorder(color: UIColor, width: CGFloat) {
        self.borderStyle = .none
        self.layer.backgroundColor = ASColor.white.cgColor

        self.layer.masksToBounds = false
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: width)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
    }
    
    func apply(style: TextFieldStyle) {
        style(self)
    }
}
