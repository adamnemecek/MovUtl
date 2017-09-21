import Cocoa

class ViewController: NSViewController, TimeLineLayerLineHeaderViewDelegate, TimeLineLayerObjectViewDelegate {
    @IBOutlet var editView: NSView!
    @IBOutlet var timeLineView: NSView!
    @IBOutlet var propertyView: NSView!
    
    @IBOutlet var seekBar: NSSlider!
    @IBOutlet var sceneMenu: NSPopUpButton!
    @IBOutlet var scaleLevel: NSLevelIndicator!
    @IBOutlet var layerScrollView: NSScrollView! {
        didSet {
            layerScrollView.hasHorizontalRuler = true
            layerScrollView.rulersVisible = true
            layerScrollView.autohidesScrollers = true
            layerScrollView.horizontalRulerView?.originOffset = 80.0
            rulerView = layerScrollView.horizontalRulerView
        }
    }
    @IBOutlet var layerScrollStackView: NSStackView!
    var rulerView: NSRulerView?
    var document: Document? {
        return view.window?.windowController?.document as? Document
    }
    var selected: [TimeLineObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let newLayerView = TimeLineLayerLineView(id: 0, frame: NSRect(x: 0, y: 0, width: 600, height: 40))
        newLayerView.headerView?.delegate = self
        newLayerView.headerView?.header?.stringValue = "Layer 0"
        layerScrollStackView.addArrangedSubview(newLayerView)
        
        let newData = TimeLineObject()
        document?.data.objects.append(newData)
        let newObject = TimeLineLayerObjectView(referencingObject: newData, frameRect: NSRect(x: newLayerView.frame.minX + 80, y: newLayerView.frame.maxY - 40, width: 100, height: 30))
        newObject.delegate = self
        newLayerView.contentsView?.addSubview(newObject)
    }
    
    // TimeLineLayerLineHeaderView's delegate methods
    func insertLayer(_ sender: Any) {
        
    }
    
    func deleteLayer(_ sender: Any) {
        
    }
    
    func exchangeLayerBelow(_ sender: Any) {
        
    }
    
    func exchangeLayerDown(_ sender: Any) {
        
    }
    
    // TimeLineLayerObjectView's delegate methods
    func selectObject(_ object:TimeLineObject) {
        selected.append(object)
    }
    
    func deselctObject(_ object:TimeLineObject) {
        selected = []
    }
    
    func changeLength(_ object:TimeLineObject) {
        
    }
    
    func deleteObject(_ object:TimeLineObject) {
        
    }
    
    func updateTLLayerObject(view: NSView, object: TimeLineObject) {
        let ratio = scaleLevel.doubleValue
        let newValue = Double(view.frame.minX - 80) * ratio
        Swift.print(newValue)
        let diff = object.endFrame - object.startFrame
        object.startFrame = UInt64(newValue)
        object.endFrame = UInt64(newValue) + diff
    }
    
    @IBAction func backFrame(_ sender: NSButton) {
        if document?.data.currentFrame != 0 {
            document?.data.currentFrame -= 1
        }
    }
    
    @IBAction func nextFrame(_ sender: NSButton) {
        if document?.data.currentFrame != document?.data.totalFrame {
            document?.data.currentFrame += 1
        }
    }
    
    @IBAction func seek(_ sender: NSSlider) {
        document?.data.currentFrame = UInt64(seekBar.intValue)
    }
    
    @IBAction func addScene(_ sender: NSMenuItem) {
        let alert = NSAlert()
        alert.messageText = "Scene Change is not implemented."
        alert.runModal()
        sceneMenu.selectItem(at: 0)
    }
    
    @IBAction func changeTimeLineScale(_ sender: NSLevelIndicator) {
        document?.data.scale = CGFloat(scaleLevel.doubleValue)
    }
    
    @IBAction func moveMovieEndToLastObjectEnd(_ sender: NSButton) {
        
    }
}

