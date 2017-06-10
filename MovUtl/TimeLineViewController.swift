import Cocoa

class TimeLineViewController : NSViewController {
    @IBOutlet var sceneMenu: NSPopUpButton!
    @IBOutlet var scaleLevel: NSLevelIndicator!
    
    @IBOutlet var layerScrollView: NSScrollView!
    @IBOutlet var layerHeadScrollView: NSScrollView!
    @IBOutlet var layerScaleScrollView: NSScrollView!
    
    override func awakeFromNib() {
        NotificationCenter.default.addObserver(self, selector: #selector(scrolled), name: NSNotification.Name.NSScrollViewWillStartLiveScroll, object: nil)
    }
    
    func scrolled() {
        layerHeadScrollView.scroll(NSPoint(x: 0, y: layerScrollView.contentSize.height))
        layerScaleScrollView.scroll(NSPoint(x: layerScaleScrollView.contentSize.width, y: 0))
    }
}
