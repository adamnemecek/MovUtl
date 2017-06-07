import Cocoa

class TimeLineView : NSView {
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
        let context = NSGraphicsContext.current()
        context?.saveGraphicsState()
        context?.shouldAntialias = false
        
        NSColor.black.set()
        for i in 0..<Int(dirtyRect.height / 40) {
            let fromPoint = CGPoint(x: 0.0, y: CGFloat(40 * i))
            let toPoint = CGPoint(x: self.frame.size.width, y: CGFloat(i * 40))
            NSBezierPath.strokeLine(from: fromPoint, to: toPoint)
        }
        
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
}
