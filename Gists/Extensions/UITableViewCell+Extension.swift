import Foundation
import SnapKit

extension UITableViewCell {
    func hideSeparator() {
        self.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
    }

    public static func buildWrapper(for view: UIView) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.contentView.addSubview(view)
        view.snp.makeConstraints { maker in
            maker.left.right.top.bottom.equalToSuperview()
        }
        return cell
    }
}
