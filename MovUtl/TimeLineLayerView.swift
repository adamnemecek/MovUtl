import Cocoa

class TimeLineLayerView : NSView {
    let layerData: LayerData?
    
    init(data layer:LayerData?) {
        layerData = layer
        super.init(frame: NSRect(x: 0, y: 0, width: 800, height: 40))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ dirtyRect: NSRect) {
        let context = NSGraphicsContext.current()
        context?.saveGraphicsState()
        context?.shouldAntialias = false
        
        NSColor.black.setStroke()
        let fromPoint = CGPoint(x: 0.0, y: 40)
        let toPoint = CGPoint(x: self.frame.size.width, y: 40)
        NSBezierPath.strokeLine(from: fromPoint, to: toPoint)
        
        for object in layerData?.objects ?? [] {
            // Render objects
            let document = window?.windowController?.document as! Document
            let scale = document.data.scale
            let pos = NSRect(x: dirtyRect.minX + CGFloat(object.startFrame) * scale, y: dirtyRect.maxY - CGFloat(object.startFrame) * scale, width: CGFloat(object.endFrame - object.startFrame) * scale, height: 30.0)
            let objectView = NSView(frame: object.frame)
            addSubview(objectView)
            
            let gradient = NSGradient(starting: NSColor(cgColor: object.firstColor)!, ending: NSColor(cgColor: object.secondColor)!)
            gradient?.draw(in: pos, angle: 0.0)
            
            let attributes = [NSFontAttributeName: NSFont(name: "Osaka", size: 4.0)!,
                              NSParagraphStyleAttributeName: NSParagraphStyle.default().mutableCopy()]
            object.name.draw(with: pos, options: NSStringDrawingOptions.usesFontLeading, attributes: attributes)
        }
        context?.restoreGraphicsState()
    }
}
