import UIKit
import SnapKit
import PINRemoteImage

class MainView: UIView, UITableViewDataSource, UITableViewDelegate {
    
    lazy var dataService = ObjectFactory.get(type: APIDataServiceProtocol.self)
    
    let tableView = UITableView(frame: CGRect.zero, style: .plain)
    
    let segmentBack = UIView()
    var segmentControl: UISegmentedControl?
    
    var model: MainViewVM?
    
    var dateFormatter = DateFormatter()
    var isDataLoading = false
    
    let reuseCellIdentifier = "MainViewCell"
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(_ dataModel: MainViewVM) {
        super.init(frame: .zero)
        model = dataModel
        
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .medium
        
        initializeView()
    }
    
    func updateModel(_ update: [Gist], refresh: Bool = false) {
        isDataLoading = false
        
        if refresh {
            if tableView.refreshControl != nil,
                tableView.refreshControl!.isRefreshing {
                tableView.refreshControl!.endRefreshing()
            }
            
            let now = Date()
            let updateString = "Last updated at " + dateFormatter.string(from: now)
            tableView.refreshControl?.attributedTitle = NSAttributedString(string: updateString)
        }
        
        model?.updateModelData(update, refresh: refresh)
        tableView.reloadData()
    }
    
    private func initializeView() {
        configureTableView()
        
        let segments = ["Public", "Starred", "My Gists"]
        segmentControl = UISegmentedControl(items: segments)
        segmentControl?.selectedSegmentIndex = 0
        
        segmentControl?.addTarget(self, action: #selector(segmentValueChanged(_:)), for: .valueChanged)
        
        addSubview(segmentBack)
        segmentBack.addSubview(segmentControl!)
        
        addSubview(tableView)
        
        segmentBack.snp.makeConstraints { (make) in
            make.top.equalTo(60)
            make.left.right.equalToSuperview()
            make.height.equalTo(44)
        }
        
        segmentControl?.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(104)
            make.left.right.bottom.equalTo(0)
        }
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseCellIdentifier, for: indexPath) as? MainViewCell
        let gist = model?.getGist(indexPath.row)
        
        let description = gist?.description ?? "No description"
        let owner = gist?.owner?.login
        
        cell?.setData(description, owner: owner)
        cell?.selectionStyle = .none
        
        setImageToCell(cell!, indexPath: indexPath)
        checkForUpdate(indexPath)
        
        return (cell)!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        model?.getDelegate()?.selectGist(indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model?.itemsCount() ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    @objc func refresh() {
        model?.getDelegate()?.updateData(true)
    }
    
    @objc func segmentValueChanged(_ sender: UISegmentedControl) {
        let segment = sender.selectedSegmentIndex
        model?.getDelegate()?.changeGistType(segment)
    }
    
    private func configureTableView() {
        tableView.register(MainViewCell.self, forCellReuseIdentifier: reuseCellIdentifier)
        tableView.separatorStyle = .singleLine
            
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tableView.estimatedRowHeight = 75.0
            
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
            
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func setImageToCell(_ cell: MainViewCell, indexPath: IndexPath) {
        let gist = model?.getGist(indexPath.row)
        let placeholder = UIImage(named: "place1")
        
        // if user has avatar
        if let urlString = gist?.owner?.avatar_url,
            let url = URL(string: urlString) {
            cell.userImage.pin_setImage(from: url, placeholderImage: placeholder) { result in
                if let cellToUpdate = self.tableView.cellForRow(at: indexPath) {
                    cellToUpdate.setNeedsLayout()
                }
            }
        }
        else {
            cell.userImage.image = placeholder
        }
    }
    
    private func checkForUpdate(_ index: IndexPath) {
        if !isDataLoading {
            let rowsLoaded = model?.itemsCount()
            guard rowsLoaded != nil, rowsLoaded! > 15 else {
                return
            }
            
            let rowsRemaining = rowsLoaded! - index.row
            let rowsToLoadFromBottom = 5
            
            if rowsRemaining <= rowsToLoadFromBottom {
                model?.getDelegate()?.updateData(false)
            }
        }
    }
}
