import UIKit
import SnapKit

class DetailedView: UIView, UITableViewDataSource, UITableViewDelegate {
    
    let tableView = UITableView(frame: CGRect.zero, style: .plain)
    var model: DetailedViewVM?
    
    let reuseCellIdentifier = "DetailedViewCell"
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(_ dataModel: DetailedViewVM) {
        super.init(frame: .zero)
        model = dataModel
        
        initializeView()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 2 : model?.getModel()?.files?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "About" : "Files"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseCellIdentifier, for: indexPath) as? DetailedViewCell
        
        let data = model?.getModel()
        var textForCell = ""
        
        switch (indexPath.section, indexPath.row) {
        case (0, 0):
            textForCell = data?.description ?? "No description"
        case (0, 1):
            textForCell = data?.owner?.login ?? "No name"
        default: // section 1
            textForCell = "data?.files?[indexPath.row].filename" // ?? ""
        }
        cell?.setData(textForCell)
        cell?.selectionStyle = .none
        
        return (cell)!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            model?.getDelegate()?.selectFile(indexPath.row)
        }
    }
    
    private func initializeView() {
        configureTableView()
        
        addSubview(tableView)
        
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        tableView.reloadData()
    }
    
    private func configureTableView() {
        tableView.register(DetailedViewCell.self, forCellReuseIdentifier: reuseCellIdentifier)
        tableView.separatorStyle = .singleLine
        
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tableView.estimatedRowHeight = 50.0
        
        tableView.delegate = self
        tableView.dataSource = self
    }
}
