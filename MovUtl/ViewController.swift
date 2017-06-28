import Cocoa

class ViewController: NSViewController {
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
        }
    }
    @IBOutlet var layerScrollStackView: NSStackView!
    
    var document: Document?
    var selected: [TimeLineObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let newLayerView = TimeLineLayerLineView(id: 0, frame: NSRect(x: layerScrollStackView.frame.minX, y: layerScrollStackView.frame.minY, width: 400, height: 40))
        layerScrollStackView.addArrangedSubview(newLayerView)
    }
    
    func updateDocument(with doc: Document) {
        document = doc
        seekBar.minValue = 0.0
        seekBar.maxValue = Double((document?.data.totalFrame)!)
        document?.data.scale = CGFloat(scaleLevel.doubleValue)
        
    }
    
    func insertLayer(_ sender: Any) {
        
    }
    
    func deleteLayer(_ sender: Any) {
        
    }
    
    func exchangeLayerBelow(_ sender: Any) {
        
    }
    
    func exchangeLayerDown(_ sender: Any) {
        
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

