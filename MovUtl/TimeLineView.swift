import Cocoa

class TimeLineView : NSView {
    var timeBarX : CGFloat = 0.0
    var pasteBoard : NSPasteboard?
    
    var layerViews : [LayerView]?
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        NSColor.black.set()
        for i in 0..<Int(dirtyRect.height / 40) {
            let fromPoint = CGPoint(x: 0.0, y: CGFloat(40 * i))
            let toPoint = CGPoint(x: self.frame.size.width, y: CGFloat(i * 40))
            NSBezierPath.strokeLine(from: fromPoint, to: toPoint)
        }
        NSColor.red.set()
        NSBezierPath.strokeLine(from: CGPoint(x: timeBarX, y: 0), to: CGPoint(x: timeBarX, y: self.frame.size.height))
        if (self.layerViews != nil) {
            for view in self.layerViews! {
                if (view != nil) {
                    for object in view.objects! {
                        let gradient = NSGradient.init(starting: object.firstColor, ending: object.secondColor)
                
                        let attributes = [NSFontAttributeName: NSFont(name: "Helvetica Neue", size: 4.0),
                                  NSParagraphStyleAttributeName: NSParagraphStyle.default().mutableCopy()]
                        gradient?.draw(in: dirtyRect, angle: 0)
                        object.name.draw(with: dirtyRect, options: NSStringDrawingOptions.usesFontLeading, attributes: attributes)
                    }
                }
            }
        }
    }
    
    override func menu(for event: NSEvent) -> NSMenu? {
        let menu = NSMenu()
        
        let addMidPoint = NSMenuItem(title: "Add Midpoint", action: #selector(self.addMidpoint(sender:)), keyEquivalent: "")
        menu.addItem(addMidPoint)
        
        return menu
    }
    
    func addMidpoint(sender: NSMenuItem) {
        
    }
    
    override func mouseDown(with event: NSEvent) {
        timeBarX = event.locationInWindow.x - 94;
        self.setNeedsDisplay(self.frame)
    }
    
    override func mouseDragged(with event: NSEvent) {
        timeBarX = event.locationInWindow.x - 94;
        self.setNeedsDisplay(self.frame)
    }
}
