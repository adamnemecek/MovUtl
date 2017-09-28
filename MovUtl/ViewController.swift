import Cocoa

class ViewController: NSViewController, TimeLineLayerLineHeaderViewDelegate, TimeLineLayerObjectViewDelegate, PropertyViewDelegate {
    @IBOutlet var editView: EditView!
    @IBOutlet var timeLineView: NSView!
    @IBOutlet var propertyView: PropertyView!
    
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
            layerScrollView.autoresizesSubviews = true
            layerScrollView.autoresizingMask = .width
        }
    }
    @IBOutlet var propertyScrollView: NSScrollView! {
        didSet {
            propertyScrollView.hasHorizontalRuler = false
            propertyScrollView.autohidesScrollers = true
        }
    }
    @IBOutlet var layerScrollContentsView: TimeLineContentsView!
    @IBOutlet var propertyComponentsContentsView: PropertyComponentsView!
    
    var rulerView: NSRulerView?
    var headerView: TimeLineLayerLineHeaderView?
    var document: Document? {
        return view.window?.windowController?.document as? Document
    }
    var selected: [TimeLineObject] = []
    
    var layerLineContentsViews : [NSView] = []
    
    override func viewWillAppear() {
        super.viewWillAppear()
        
        propertyView.delegate = self
        
        headerView = TimeLineLayerLineHeaderView(id: 0, frame: NSRect(origin: .zero, size: CGSize(width: 80, height: 40)))
        headerView?.delegate = self
        layerScrollView.addFloatingSubview(headerView!, for: .horizontal)
        
        let newLayerView = TimeLineLayerLineView(id: 0)
        layerScrollContentsView.addSubview(newLayerView)
        layerLineContentsViews.append(newLayerView.contentsView)
    }
    
    
    func objectsOn(current: UInt64) -> [TimeLineObject] {
        var result : [TimeLineObject] = []
        
        for object in document!.data.objects {
            if object.startFrame <= current && current <= object.endFrame {
                
                if object.isEnabled {
                    result.append(object)
                }
                
            }
        }
        
        return result
    }
    
    
    func updateTitle() {
        layerScrollContentsView.updateVar(current: CGFloat((document?.data.currentFrame)!), playing: 0)
        document?.mainWindow.window?.title = document!.mainWindow.windowTitle(forDocumentDisplayName: document!.displayName)
        
        editView.needsDisplay = true
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
        propertyComponentsContentsView.updateComponentsView(objects: selected)
        propertyView.startFrameNumField?.intValue = Int32(object.startFrame)
        propertyView.endFrameNumField?.intValue = Int32(object.endFrame)
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
        let newValue = Double(view.frame.minX) * ratio
        
        let diff = object.endFrame - object.startFrame
        object.startFrame = UInt64(newValue)
        object.endFrame = UInt64(newValue) + diff
        
        propertyView.startFrameNumField?.intValue = Int32(object.startFrame)
        propertyView.endFrameNumField?.intValue = Int32(object.endFrame)
    }
    
    // PropertyView's delegate methods
    func pushedEnable(_ a:Any) {
        
    }
    func pushedIn3D(_ a:Any) {
        
    }
    func pushedReset(_ a:Any) {
        
    }
    func pushedModeChange(_ a:Any) {
        
    }
    
    func editStartFrame(_ newValue:UInt64) {
        for object in selected {
            object.startFrame = newValue
        }
        for contentsSub in layerScrollContentsView.subviews {
            if let layer = contentsSub as? TimeLineLayerLineView {
                for layerContentsSub in layer.contentsView.subviews {
                    if let object = layerContentsSub as? TimeLineLayerObjectView {
                        object.needsDisplay = true
                    }
                }
            }
        }
    }
    
    func editEndFrame(_ newValue:UInt64) {
        for object in selected {
            object.endFrame = newValue
        }
        for contentsSub in layerScrollContentsView.subviews {
            if let layer = contentsSub as? TimeLineLayerLineView {
                for layerContentsSub in layer.contentsView.subviews {
                    if let object = layerContentsSub as? TimeLineLayerObjectView {
                        object.needsDisplay = true
                    }
                }
            }
        }
    }
    
    @IBAction func backFrame(_ sender: NSButton) {
        if document?.data.currentFrame != 0 {
            document?.data.currentFrame -= 1
            updateTitle()
        }
    }
    
    @IBAction func nextFrame(_ sender: NSButton) {
        if document?.data.currentFrame != document?.data.totalFrame {
            document?.data.currentFrame += 1
            updateTitle()
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

