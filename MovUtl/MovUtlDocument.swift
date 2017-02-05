import Cocoa

class MovUtlDocument: NSDocument {
    var mainWindow : MainViewController!
    var timeLine : TimeLineViewController!
    var componentsPanel : NSWindowController!
    
    var layerViews : [LayerView] = []
    
    override func read(from data: Data, ofType typeName: String) throws {
        
    }
    
    override func data(ofType typeName: String) throws -> Data {
        let data = Data()
        
        return data
    }
    
    override init() {
        
    }
    
    override func makeWindowControllers() {
        
    }
}
