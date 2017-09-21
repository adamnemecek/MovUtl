import Cocoa

class MovUtlDocumentController : NSDocumentController {
    override func documentClass(forType typeName: String) -> AnyClass? {
        return Document.classForCoder()
    }
    
    override func openDocument(withContentsOf url: URL, display displayDocument: Bool, completionHandler: @escaping (NSDocument?, Bool, Error?) -> Void) {
        
    }
    
    override func closeAllDocuments(withDelegate delegate: Any?, didCloseAllSelector: Selector?, contextInfo: UnsafeMutableRawPointer?) {
        
    }
    
    override func saveAllDocuments(_ sender: Any?) {
        
    }
}
