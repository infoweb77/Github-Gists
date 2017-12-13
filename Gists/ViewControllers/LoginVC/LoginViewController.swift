import UIKit
import SnapKit

protocol AuthFlowDelegate: class {
    func proceedLogin(login: String, password: String)
}

class LoginViewController: UIViewController, LoginViewDelegate {
    
    private var loginView: LoginView?
    internal weak var delegate: AuthFlowDelegate?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = ASColor.white
        
        initView()
    }
    
    internal func login(login: String, password: String) {
        delegate?.proceedLogin(login: login, password: password)
        dismiss(animated: true)
    }

    private func initView() {
        loginView = LoginView()
        loginView?.delegate = self
        
        view.addSubview(loginView!)
        loginView!.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }

}

