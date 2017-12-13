import Foundation
import HandyJSON

open class Gist: HandyJSON {
    internal var id: String?
    internal var description: String?
    internal var url: String?
    
    internal var owner: Owner?
    
    internal var files: [File]?
    
    internal var created_at: String?
    internal var updated_at: String?
    
    public required init() {}
}
