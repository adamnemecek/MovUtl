import Cocoa

class TimeLineLayerLineView: NSView {
    var contentsView: NSView
    
    init(id: UInt, frame frameRect: NSRect) {
        let header = TimeLineLayerLineHeaderView(frame: NSRect(origin: frameRect.origin, size: CGSize(width: 120, height: frameRect.size.height)))
        header.header.stringValue = "\(id)"
        contentsView = NSView(frame: NSRect(origin: NSPoint(x: frameRect.origin.x + header.frame.size.width, y: frameRect.origin.y), size: frameRect.size))
        
        super.init(frame: frameRect)
        
        addSubview(header)
        addSubview(contentsView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class TimeLineLayerLineHeaderView: NSView {
    var header: NSTextField
    
    override init(frame frameRect: NSRect) {
        header = NSTextField(frame: frameRect)
        super.init(frame: frameRect)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func menu(for event: NSEvent) -> NSMenu? {
        let menu = NSMenu(title: "")
        
        menu.addItem(withTitle: "Insert A Layer Below", action: #selector(ViewController.insertLayer(_:)), keyEquivalent: "")
        menu.addItem(withTitle: "Delete This Layer \(header.stringValue)", action: #selector(ViewController.deleteLayer(_:)), keyEquivalent: "")
        menu.addItem(withTitle: "Exchange Below", action: #selector(ViewController.exchangeLayerBelow(_:)), keyEquivalent: "")
        menu.addItem(withTitle: "Exchange Down", action: #selector(ViewController.exchangeLayerDown(_:)), keyEquivalent: "")
        
        return menu
    }
}

class TimeLineLayerObjectView: NSView {
    var startPos: NSPoint = NSPoint.zero
    var object: TimeLineObject!
    
    init(referencingObject: TimeLineObject, frameRect: NSRect) {
        object = referencingObject
        super.init(frame: frameRect)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func mouseDown(with event: NSEvent) {
        startPos = event.locationInWindow
        
        guard let vc = (window?.windowController?.contentViewController as! ViewController?) else {
            return
        }
        
        if event.modifierFlags.contains(.shift) {
            vc.selected = []
        }
        vc.selected.append(object)
    }
    
    override func mouseDragged(with event: NSEvent) {
        if event.locationInWindow.x > startPos.x && object.startFrame <= 0 {
            // if dragged to right
            object.startFrame -= 1
            object.endFrame -= 1
        }
        if event.locationInWindow.x < startPos.x {
            // if dragged to left
            object.startFrame += 1
            object.endFrame += 1
        }
        if event.locationInWindow.y > startPos.y && object.layerDepth <= 0 {
            // if dragged to up
            object.layerDepth -= 1
        }
        if event.locationInWindow.y < startPos.y {
            // if dragged to down
            object.layerDepth += 1
        }
    }
    
    override func mouseUp(with event: NSEvent) {
        guard let doc = window?.windowController?.document as! Document? else {
            return
        }
        
        // Update movie end
        if doc.data.totalFrame < object.endFrame {
            doc.data.totalFrame = object.endFrame
        }
    }
    
    override func menu(for event: NSEvent) -> NSMenu? {
        let menu = NSMenu(title: "")
        
        menu.addItem(withTitle: "Move To...", action: nil, keyEquivalent: "")
        menu.addItem(withTitle: "Change Length...", action: nil, keyEquivalent: "")
        menu.addItem(withTitle: "Delete", action: nil, keyEquivalent: "")
        menu.addItem(withTitle: "Add A Central Point", action: nil, keyEquivalent: "")
        menu.addItem(withTitle: "Change To Group Object", action: nil, keyEquivalent: "")
        
        return menu
    }
}
