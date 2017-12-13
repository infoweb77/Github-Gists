import Foundation
import HandyJSON

open class File: HandyJSON {
    
    internal var filename: String?
    internal var raw_url: String?
    internal var content: String?
    
    public required init() {}
}

open class Owner: HandyJSON {
    
    internal var login: String?
    internal var avatar_url: String?
    
    public required init() {}
}

