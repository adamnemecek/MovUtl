import Cocoa

class TimeLineLayerHeadView : NSView {
    var title: NSText!
    
    init(frame frameRect: NSRect, depth id: Int) {
        super.init(frame: frameRect)
        title = NSText(frame: frameRect)
        title.string = "Layer \(id)"
        title.sizeToFit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
