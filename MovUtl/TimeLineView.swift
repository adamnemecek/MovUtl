import Cocoa

class TimeLineView : NSStackView {
    var selectedPos: NSPoint = NSPoint.zero
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
        let context = NSGraphicsContext.current()
        context?.saveGraphicsState()
        context?.shouldAntialias = false
        
        NSColor.black.set()
        let fromPoint = CGPoint(x: 0.0, y: 40)
        let toPoint = CGPoint(x: self.frame.size.width, y: 40)
        NSBezierPath.strokeLine(from: fromPoint, to: toPoint)
        
        let document = self.window?.windowController?.document as! Document
        
        for layer in document.layers {
            for object in layer.objects ?? [] {
                // Render objects
                let scale = document.scale
                let pos = NSRect(x: dirtyRect.minX + CGFloat(object.startFrame) * scale, y: dirtyRect.maxY - CGFloat(object.startFrame) * scale, width: CGFloat(object.endFrame - object.startFrame) * scale, height: 30.0)
                let objectView = NSView(frame: pos)
                addSubview(objectView)
                
                let gradient = NSGradient(starting: NSColor(cgColor: object.firstColor)!, ending: NSColor(cgColor: object.secondColor)!)
                gradient?.draw(in: pos, angle: 0.0)
                
                let attributes = [NSFontAttributeName: NSFont(name: "Osaka", size: 4.0)!,
                                  NSParagraphStyleAttributeName: NSParagraphStyle.default().mutableCopy()]
                object.name.draw(with: pos, options: NSStringDrawingOptions.usesFontLeading, attributes: attributes)
            }
        }
        
        context?.restoreGraphicsState()
    }
    
    override func rightMouseDown(with event: NSEvent) {
        selectedPos = event.locationInWindow
        
        let menu = NSMenu(title: "")
        
        menu.popUp(positioning: nil, at: event.locationInWindow, in: self)
    }
}
