import UIKit
import SnapKit

class MainViewCell: UITableViewCell {
    
    var userImage = UIImageView()
    
    private var titleLabel = UILabel()
    private var ownerLabel = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupView()
    }
    
    private func setupView() {

        titleLabel.setStyle(weight: ASFonts.semibold, fontSize: 20, textColor: ASColor.black)
        
        ownerLabel.setStyle(weight: ASFonts.regular, fontSize: 14, textColor: ASColor.warmGray)
        ownerLabel.lineBreakMode = .byTruncatingTail
        
        contentView.addSubview(userImage)
        contentView.addSubview(titleLabel)
        contentView.addSubview(ownerLabel)
        
        userImage.snp.makeConstraints { (make) in
            make.left.equalTo(12)
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: 44, height: 44))
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(16)
            make.left.equalTo(70)
            make.right.equalTo(-20)
            make.bottom.equalTo(-36)
        }
        
        ownerLabel.snp.makeConstraints { (make) in
            make.left.right.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.height.equalTo(15)
        }
    }
    
    func setData(_ titleText: String, owner: String?) {
        titleLabel.text = titleText
        
        if owner != nil {
            ownerLabel.text = owner
        } else {
            titleLabel.snp.updateConstraints { (make) in
                make.bottom.equalTo(-16)
            }
            ownerLabel.snp.updateConstraints { (make) in
                make.height.equalTo(0)
            }
            setNeedsLayout()
        }
    }
    
    override func prepareForReuse() {
        userImage.image = nil
        titleLabel.text = ""
        ownerLabel.text = ""
    }
}
