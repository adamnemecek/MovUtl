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
    @IBOutlet var layerHeadScrollView: NSScrollView!
    
    override func awakeFromNib() {
        NSScrollView.setRulerViewClass(TimeLineRulerView.classForCoder())
        NotificationCenter.default.addObserver(self, selector: #selector(scrolled), name: NSNotification.Name.NSScrollViewWillStartLiveScroll, object: nil)
    }
    
    func scrolled() {
        layerHeadScrollView.scroll(NSPoint(x: 0, y: layerScrollView.contentSize.height))
    }
}
