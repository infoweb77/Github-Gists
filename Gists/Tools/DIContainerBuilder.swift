import Foundation
import Swinject
import Alamofire

class DIContainerBuilder {
    public static func build() -> Container {
        let container = Container()
        
        container.register(ApiClientProtocol.self, factory: { _ -> ApiClientProtocol in
            return ApiClient()
        })
        
        container.register(APIDataServiceProtocol.self) { (resolver: Resolver) -> APIDataServiceProtocol in
                return APIDataService(resolver.resolve(ApiClientProtocol.self))
            }
            .inObjectScope(.container)
        
        container.register(APIAuthServiceProtocol.self) { (resolver: Resolver) -> APIAuthServiceProtocol in
                return APIAuthService(resolver.resolve(ApiClientProtocol.self))
            }
            .inObjectScope(.container)
        
        return container
    }
}

