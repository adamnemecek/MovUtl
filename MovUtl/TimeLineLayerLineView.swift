import Cocoa

class TimeLineLayerLineView: NSView {
    init(id: UInt, frame frameRect: NSRect) {
        super.init(frame: frameRect)
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
    
    override func rightMouseDown(with event: NSEvent) {
        let menu = NSMenu(title: "")
        
        menu.addItem(NSMenuItem(title: "Insert A Layer Below", action: nil, keyEquivalent: ""))
        menu.addItem(NSMenuItem(title: "Delete This Layer \(header.stringValue)", action: nil, keyEquivalent: ""))
        menu.addItem(NSMenuItem(title: "Exchange Below", action: nil, keyEquivalent: ""))
        menu.addItem(NSMenuItem(title: "Exchange Down", action: nil, keyEquivalent: ""))
        
        menu.popUp(positioning: nil, at: event.locationInWindow, in: self)
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
    
    override func rightMouseDown(with event: NSEvent) {
        let menu = NSMenu(title: "")
        
        menu.addItem(NSMenuItem(title: "Move To...", action: nil, keyEquivalent: ""))
        menu.addItem(NSMenuItem(title: "Change Length...", action: nil, keyEquivalent: ""))
        menu.addItem(NSMenuItem(title: "Delete", action: nil, keyEquivalent: ""))
        menu.addItem(NSMenuItem(title: "Add A Central Point", action: nil, keyEquivalent: ""))
        menu.addItem(NSMenuItem(title: "Change To Group Object", action: nil, keyEquivalent: ""))
        
        menu.popUp(positioning: nil, at: event.locationInWindow, in: self)
    }
}
