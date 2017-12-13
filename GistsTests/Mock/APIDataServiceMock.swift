import Foundation

open class APIDataServiceMock: APIDataServiceProtocol {
    
    var mockMonitor: MockMonitor = MockMonitor("APIDataServiceMock")
    
    func fetchGistsOfType(_ gistType: Int, pageToLoad: String?, _ completionHandler: @escaping (_ data: [Gist]?, _ url: String?) -> Void) {
        mockMonitor.registerCall("fetchGistsOfType", args: ["gistType": gistType, "pageToLoad": pageToLoad])
    }
    
    func clearCache() {
        mockMonitor.registerCall("clearCache", args: [:])
    }
}
