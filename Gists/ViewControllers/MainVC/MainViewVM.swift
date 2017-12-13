import Foundation

protocol MainViewDelegate: class {
    func selectGist(_ num: Int)
    func updateData(_ refresh: Bool)
    func changeGistType(_ num: Int)
}

class MainViewVM {
    private var data: [Gist]?
    private weak var delegate: MainViewDelegate?
    
    init(data: [Gist], delegate: MainViewDelegate) {
        self.data = data
        self.delegate = delegate
    }
    
    func getGist(_ num: Int) -> Gist {
        return (data?[num])!
    }
    
    func getDelegate() -> MainViewDelegate? {
        return delegate
    }
    
    func updateModelData(_ update: [Gist], refresh: Bool = false) {
        if refresh {
            data = update
        } else {
            data?.append(contentsOf: update)
        }
    }
    
    func itemsCount() -> Int {
        return data?.count ?? 0
    }
}
