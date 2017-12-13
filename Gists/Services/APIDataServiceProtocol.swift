import UIKit

enum GistTypes: Int {
    case Public = 0
    case Starred
    case MyGists
}

protocol APIDataServiceProtocol {
    func fetchGistsOfType(_ gistType: Int, pageToLoad: String?,_ completionHandler: @escaping (_ data: [Gist]?, _ url: String?) -> Void)
    func clearCache()
}
