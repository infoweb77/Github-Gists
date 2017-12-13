import UIKit
import SnapKit

class DetailedViewCell: UITableViewCell {
    
    private var titleLabel = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupView()
    }
    
    private func setupView() {
        titleLabel.setStyle(weight: ASFonts.semibold, fontSize: 16, textColor: ASColor.darkGray)

        contentView.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { (make) in
            make.edges.equalTo(0).inset(UIEdgeInsets(top: 12, left: 20, bottom: 12, right: 20))
        }
    }
    
    func setData(_ titleText: String) {
        titleLabel.text = titleText
    }
}

