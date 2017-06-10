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
    @IBOutlet var layerScrollStackView: TimeLineView!
    @IBOutlet var layerHeadScrollView: NSScrollView!
    @IBOutlet var layerHeadStackView: TimeLineHeadView!
    
    var document: Document?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func updateDocument(with doc: Document) {
        document = doc
        seekBar.maxValue = Double((document?.data.totalFrame)!)
        seekBar.integerValue = Int((document?.data.currentFrame)!)
        
        document?.data.scale = CGFloat(scaleLevel.doubleValue)
        
    }
    
    @IBAction func backFrame(_ sender: NSButton) {
        
    }
    
    @IBAction func nextFrame(_ sender: NSButton) {
    
    }
    
    @IBAction func seek(_ sender: NSSlider) {
        
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
}

