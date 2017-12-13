import UIKit
import SnapKit
import SafariServices

class DetailedViewController: UIViewController, DetailedViewDelegate {
    
    private var detailedView: DetailedView?
    private var viewModel: DetailedViewVM?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    init(_ model: Gist) {
        super.init(nibName: nil, bundle: nil)
        viewModel = DetailedViewVM(model: model, delegate: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = ASColor.white
        navigationItem.title = "Detailed"
        
        initView()
    }
    
    public func selectFile(_ num: Int) {
        let data = viewModel?.getModel()
        
        guard let file = data?.files?[num],
            let urlString = file.raw_url,
            let url = URL(string: urlString) else {
                return
        }
        
        let safariVC = SFSafariViewController(url: url)
        safariVC.title = "file.filename"
        navigationController?.pushViewController(safariVC, animated: true)
    }
        
    private func initView() {
        detailedView = DetailedView(viewModel!)
        
        view.addSubview(detailedView!)

        detailedView!.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }

}
