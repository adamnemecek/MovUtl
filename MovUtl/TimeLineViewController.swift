import Cocoa

class TimeLineViewController : NSViewController {
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
    @IBOutlet var layerHeadStackView: NSStackView!
    
    var startPoint: NSPoint = NSPoint.zero
    var shapeLayer: CAShapeLayer!
    
    override func awakeFromNib() {
        NSScrollView.setRulerViewClass(TimeLineRulerView.classForCoder())
        NotificationCenter.default.addObserver(self, selector: #selector(scrolled), name: NSNotification.Name.NSScrollViewWillStartLiveScroll, object: nil)
    }
    
    func scrolled() {
        layerHeadScrollView.scroll(NSPoint(x: 0, y: layerScrollView.contentSize.height))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    @IBAction func addScene(_ sender: NSMenuItem) {
        let alert = NSAlert()
        alert.messageText = "Scene Change is not implemented."
        alert.runModal()
        sceneMenu.selectItem(at: 0)
    }
    
    @IBAction func changeTimeLineScale(_ sender: NSLevelIndicator) {
        let document = view.window?.windowController?.document as! Document
        document.scale = CGFloat(scaleLevel.doubleValue)
    }
}

