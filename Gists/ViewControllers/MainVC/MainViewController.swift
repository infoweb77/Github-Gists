import UIKit
import SnapKit
import SafariServices

class MainViewController: UIViewController, MainViewDelegate,
    AuthFlowDelegate, SFSafariViewControllerDelegate {
    
    lazy var dataService = ObjectFactory.get(type: APIDataServiceProtocol.self)
    lazy var authService = ObjectFactory.get(type: APIAuthServiceProtocol.self)
    
    private var mainView: MainView?
    private var viewModel: MainViewVM?
    
    private var safariVC: SFSafariViewController?

    private var nextPageURLString: String?
    private var gistType = GistTypes.Public.rawValue

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        definesPresentationContext = true
        
        view.backgroundColor = ASColor.white
        navigationItem.title = "Master"
        
        loadInitialData()
    }
    
    func loadInitialData() {
        dataService?.fetchGistsOfType(gistType, pageToLoad: nil) { [weak self] (gists, nextPage) in
            self?.nextPageURLString = nextPage
            
            let model = MainViewVM(data: gists!, delegate: self!)
            self?.viewModel = model
            
            self?.mainView = MainView(model)
            self?.initView()
        }
    }
    
    func updateData(_ refresh: Bool) {
        mainView?.isDataLoading = true
        
        if refresh {
            nextPageURLString = nil
            dataService?.clearCache()
        }
        
        dataService?.fetchGistsOfType(gistType, pageToLoad: nextPageURLString) { [weak self] (gists, nextPage) in
            self?.nextPageURLString = nextPage
            self?.mainView?.updateModel(gists!, refresh: refresh)
        }
    }
    
    func selectGist(_ num: Int) {
        guard let gist = self.viewModel?.getGist(num) else {
            return
        }
        let detailedVC = DetailedViewController(gist)
        navigationController?.pushViewController(detailedVC, animated: true)
    }
    
    func changeGistType(_ num: Int) {
        if num > 0 {
            guard let hasToken = authService?.hasTokeh() else {
                return
            }
            if !hasToken {
                showLogin()
                return
            }
        }
        gistType = num
        updateData(true)
    }
    
    internal func proceedLogin(login: String, password: String) {
        guard let authUrl = authService?.URLToStartOAuth2Login() else {
            return
        }
        safariVC = SFSafariViewController(url: authUrl)
        safariVC?.modalPresentationStyle = .overCurrentContext
        safariVC?.delegate = self

        guard let webVC = safariVC else {
            return
        }
        present(webVC, animated: true)
    }
    
    private func initView() {
        guard let main = mainView else {
            return
        }
        view.addSubview(main)
        
        main.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    private func showLogin() {
        let loginVC = LoginViewController()
        loginVC.delegate = self
        loginVC.modalPresentationStyle = .overFullScreen
        self.present(loginVC, animated: true)
    }

    // MARK: - Safari ViewController Delegate
    func safariViewController(_ controller: SFSafariViewController, didCompleteInitialLoad didLoadSuccessfully: Bool) {
        if !didLoadSuccessfully {
            controller.dismiss(animated: true)
        }
    }
}

