import Cocoa

class TimeLineView : NSStackView {
    var selectedPos: NSPoint = NSPoint.zero
    
    override func rightMouseDown(with event: NSEvent) {
        selectedPos = event.locationInWindow
        
        let menu = NSMenu(title: "")
        
        menu.popUp(positioning: nil, at: event.locationInWindow, in: self)
    }
}
