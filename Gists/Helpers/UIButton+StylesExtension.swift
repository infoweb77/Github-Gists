import UIKit

typealias ButtonStyle = ((_ button: UIButton) -> Void)

extension UIButton {
    public func setStyle(
            bgColor: UIColor = ASColor.clear,
            titleNormalColor: UIColor = ASColor.black,
            borderColor: UIColor = ASColor.black,
            borderWidth: CGFloat = 1,
            cornerRadius: CGFloat = 0) {

        self.backgroundColor = bgColor
        self.setTitleColor(titleNormalColor, for: .normal)
        self.layer.borderColor = borderColor.cgColor
        self.layer.borderWidth = borderWidth
        self.layer.cornerRadius = cornerRadius
    }
    
    func apply(style: ButtonStyle) {
        style(self)
    }
}
