import Cocoa

class MovUtlDocumentController : NSDocumentController {
    override func documentClass(forType typeName: String) -> AnyClass? {
        return MovUtlDocument.classForCoder()
    }
    
    
}
