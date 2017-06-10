import Cocoa

class TimeLineHeadView : NSStackView {
    override func awakeFromNib() {
        super.awakeFromNib()
        addArrangedSubview(TimeLineLayerHeadView(frame: NSRect(x: 0, y: 174, width: 90, height: 40), depth: 0))
    }
    
    override func rightMouseDown(with event: NSEvent) {
        let selectedPos = event.locationInWindow
        var selectedLayer: NSView?
        for view in arrangedSubviews {
            if view.frame.contains(selectedPos) {
                selectedLayer = view
            }
        }
        Swift.print("X:\(selectedPos.x), Y:\(selectedPos.y)")
        
        let menu = NSMenu(title: "")
        
        menu.addItem(NSMenuItem(title: "Add Layer Below", action: #selector(addLayer(_:)), keyEquivalent: ""))
        
        menu.popUp(positioning: nil, at: event.locationInWindow, in: self)
    }
    
    func addLayer(_ sender:Any) {
        
    }
    
    func removeLayer(_ sender:Any) {
        
    }
}
