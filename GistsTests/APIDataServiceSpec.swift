import Quick
import Nimble
import Swinject
import Alamofire

class APIDataServiceSpec: QuickSpec {
    
    override func spec() {
        
        describe("fetchGistsOfType") {
            
            context("on success fetch data") {
                
                it("should load data from api and pass identifiers to callback") {
                    let notificationsMonitor = NotificationsMonitor()
                    let api = ApiClientMock(json: "[{\"id\":\"135\",\"url\":\"someurl\"}]")
                    
                    api.mockMonitor.expectCall(of: "performGet") { args in
                        let url = args["url"] as? String
                        return url != nil && url!.contains("gists/public")
                    }
                    
                    var completionHandlerWasCalled = false
                    
                    let service = APIDataService(api)
                    service.fetchGistsOfType(0, pageToLoad: nil) { gist, _ in
                        completionHandlerWasCalled = gist?[0].id == "135"
                    }
                    
                    expect(completionHandlerWasCalled).to(equal(true))
                    expect(expression: { api.mockMonitor.verifyAll() }).to(beEmpty())
                    expect(expression: { notificationsMonitor.hasAnyNotifications }).to(equal(false))
                }
            }
            
            context("on api error") {
                
                it("should notify and no callback") {
                    let notificationsMonitor = NotificationsMonitor()
                    let api = ApiClientMock(error: ApiRequestError())
                    
                    var completionHandlerWasCalled = false
                    
                    let service = APIDataService(api)
                    service.fetchGistsOfType(0, pageToLoad: nil) { _ in
                        completionHandlerWasCalled = true
                    }
                    
                    expect(completionHandlerWasCalled).to(equal(false))
                    expect(expression: { notificationsMonitor.unexpectedApiError }).to(equal(true))
                }
            }
            
            context("on invalid json response") {
                
                it("should notify and no callback") {
                    let notificationsMonitor = NotificationsMonitor()
                    let api = ApiClientMock(json: "")
                    
                    var completionHandlerWasCalled = false
                    
                    let service = APIDataService(api)
                    service.fetchGistsOfType(0, pageToLoad: nil) { _ in
                        completionHandlerWasCalled = true
                    }
                    
                    expect(completionHandlerWasCalled).to(equal(false))
                    expect(expression: { notificationsMonitor.guardViolation }).to(equal(true))
                }
            }
        }
    }
}
