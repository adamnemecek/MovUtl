import Cocoa

class TimeLineViewController : NSViewController {
    var headView: NSRulerView?
    @IBOutlet var timeLineView: TimeLineView!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        headView = NSRulerView(scrollView: timeLineView, orientation: .horizontalRuler)
    }
}
