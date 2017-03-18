import Cocoa

class MovUtlDocument: NSDocument {
    var mainWindow : NSWindowController!
    var timeLine : NSWindowController!
    var componentsPanel : NSWindowController!
    
    var layerViews : [LayerView] = []
    
    override func read(from data: Data, ofType typeName: String) throws {
    }
    
    override func data(ofType typeName: String) throws -> Data {
        var data = Data()
        for layer in layerViews {
            for object in layer.objects! {
                data.append("StartFrame:\(object.startFrame)".data(using: .utf8)!)
                data.append("EndFrame:\(object.endFrame)".data(using: .utf8)!)
                data.append("Name:\(object.name)".data(using: .utf8)!)
                data.append("FirstColorR:\(object.firstColor.redComponent)".data(using: .utf8)!)
                data.append("FirstColorG:\(object.firstColor.greenComponent)".data(using: .utf8)!)
                data.append("FirstColorB:\(object.firstColor.blueComponent)".data(using: .utf8)!)
                data.append("SecondColorR:\(object.secondColor.redComponent)".data(using: .utf8)!)
                data.append("SecondColorG:\(object.secondColor.greenComponent)".data(using: .utf8)!)
                data.append("SecondColorB:\(object.secondColor.blueComponent)".data(using: .utf8)!)
                data.append("UseCameraControll:\(object.useCameraControll)".data(using: .utf8)!)
                data.append("UseClipping:\(object.useClipping)".data(using: .utf8)!)
                data.append("UseMouseMoving:\(object.useMouseMoving)".data(using: .utf8)!)
                data.append("IsEnabled:\(object.isEnabled)".data(using: .utf8)!)
                data.append("LayerDepth:\(object.layer?.zPosition)".data(using: .utf8)!)
                data.append("ObjectType:\(object.objectType)".data(using: .utf8)!)
                data.append("ReferencingFile:\(object.referencingFile)".data(using: .utf8)!)
            }
        }
        return data
    }
    
    override init() {
        super.init()
    }
    
    override func makeWindowControllers() {
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        mainWindow = storyboard.instantiateController(withIdentifier: "Main Window") as! NSWindowController
        timeLine = storyboard.instantiateController(withIdentifier: "Time Line Window") as! NSWindowController
        componentsPanel = storyboard.instantiateController(withIdentifier: "Components Panel") as! NSWindowController
        mainWindow.showWindow(nil)
        timeLine.showWindow(nil)
        componentsPanel.showWindow(nil)
    }
}