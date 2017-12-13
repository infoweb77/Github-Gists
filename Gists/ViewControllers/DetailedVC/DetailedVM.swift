import Foundation

protocol DetailedViewDelegate: class {
    func selectFile(_ num: Int)
}

class DetailedViewVM {
    private var model: Gist?
    private weak var delegate: DetailedViewDelegate?
    
    init(model: Gist, delegate: DetailedViewDelegate) {
        self.model = model
        self.delegate = delegate
    }
    
    func getModel() -> Gist? {
        return model
    }
    
    func getDelegate() -> DetailedViewDelegate? {
        return delegate
    }
}
