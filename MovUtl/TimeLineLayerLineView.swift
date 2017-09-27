import Cocoa

class TimeLineContentsView: FlippedView {
    var renderingEditBarX : CGFloat = 80
    var renderRatio : CGFloat = 1
    
    override func draw(_ dirtyRect: NSRect) {
        renderRatio = ((window?.contentViewController as! ViewController).document?.data.scale)!
        
        let scrollAmount = (self.superview?.superview as! NSScrollView).documentVisibleRect.origin.x
        
        let playingFrame = -1 //TODO implement to player
        let endFrame = ((window?.contentViewController as! ViewController).document?.data.totalFrame)!
        
        NSColor.red.setStroke()
        let editBarPath = NSBezierPath()
        editBarPath.move(to: NSPoint(x: CGFloat(renderingEditBarX) * renderRatio + scrollAmount, y: 0))
        editBarPath.line(to: NSPoint(x: CGFloat(renderingEditBarX) * renderRatio + scrollAmount, y: frame.height))
        editBarPath.stroke()
        
        
        NSColor.green.setStroke()
        let playBarPath = NSBezierPath()
        
        
        NSColor.gray.setStroke()
        let movieEndPath = NSBezierPath()
        let patArray : [CGFloat] = [5.0, 2.0]
        movieEndPath.setLineDash(patArray, count: 2, phase: 0)
        movieEndPath.move(to: NSPoint(x: CGFloat(endFrame) * renderRatio + scrollAmount, y: 0))
        movieEndPath.line(to: NSPoint(x: CGFloat(endFrame) * renderRatio + scrollAmount, y: frame.height))
        movieEndPath.stroke()
    }
    
    override func mouseDown(with event: NSEvent) {
        if event.locationInWindow.x >= 80 {
            renderingEditBarX = event.locationInWindow.x
        }
        self.needsDisplay = true
    }
    
    override func mouseDragged(with event: NSEvent) {
        if event.locationInWindow.x >= 80 {
            renderingEditBarX = event.locationInWindow.x
        }
        self.needsDisplay = true
    }
    
    override func mouseUp(with event: NSEvent) {
        (window?.contentViewController as! ViewController).document?.data.currentFrame = UInt64((renderingEditBarX - 80.0) / renderRatio)
    }
}

class TimeLineLayerLineView: NSView {
    var contentsView: NSView!
    
    init(id: Int) {
        super.init(frame: NSRect(x: 0, y: id * 40, width: 600, height: 40))
        
        contentsView = NSView(frame: NSRect(origin: NSPoint(x: 80, y: 0), size: frame.size))
        
        addSubview(contentsView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

@objc protocol TimeLineLayerLineHeaderViewDelegate {
    func insertLayer(_:Any)
    func deleteLayer(_:Any)
    func exchangeLayerBelow(_:Any)
    func exchangeLayerDown(_:Any)
}

class TimeLineLayerLineHeaderView: NSView {
    var header: NSTextField!
    
    weak var delegate: TimeLineLayerLineHeaderViewDelegate?
    
    init(id: Int, frame frameRect: NSRect) {
        header = NSTextField(labelWithString: "Layer \(id)")
        header.frame = NSRect(x: 0, y: 10, width: 80, height: 20)
        header.alignment = .center
        header.isEditable = false
        
        super.init(frame: frameRect)
        
        addSubview(header)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ dirtyRect: NSRect) {
        NSColor.lightGray.setFill()
        NSBezierPath.fill(dirtyRect)
        
        NSColor.black.setStroke()
        let framePath = NSBezierPath()
        framePath.lineWidth = 0.4
        framePath.move(to: .zero)
        framePath.line(to: NSPoint(x: frame.maxX, y: 0))
        framePath.line(to: NSPoint(x: frame.maxX, y: frame.maxY))
        framePath.line(to: NSPoint(x: 0, y: frame.maxY))
        framePath.close()
        framePath.stroke()
        
        super.draw(dirtyRect)
    }
    
    override func menu(for event: NSEvent) -> NSMenu? {
        let menu = NSMenu(title: "")
        
        menu.addItem(withTitle: "Insert A Layer Below", action: #selector(delegate?.insertLayer(_:)), keyEquivalent: "")
        menu.addItem(withTitle: "Delete This \(header.stringValue)", action: #selector(delegate?.deleteLayer(_:)), keyEquivalent: "")
        menu.addItem(withTitle: "Exchange Below", action: #selector(delegate?.exchangeLayerBelow(_:)), keyEquivalent: "")
        menu.addItem(withTitle: "Exchange Down", action: #selector(delegate?.exchangeLayerDown(_:)), keyEquivalent: "")
        
        return menu
    }
}

@objc protocol TimeLineLayerObjectViewDelegate {
    func selectObject(_:TimeLineObject)
    func deselctObject(_:TimeLineObject)
    func changeLength(_:TimeLineObject)
    func deleteObject(_:TimeLineObject)
    
    func updateTLLayerObject(view:NSView, object:TimeLineObject)
}

class TimeLineLayerObjectView: NSView {
    var startPos: NSPoint = NSPoint.zero
    var object: TimeLineObject
    
    weak var delegate: TimeLineLayerObjectViewDelegate?
    
    var nameLabel: NSTextField?
    
    init(referencingObject: TimeLineObject, frameRect: NSRect) {
        object = referencingObject
        nameLabel = NSTextField(labelWithString: object.name)
        nameLabel?.frame = NSRect(origin: .zero, size: frameRect.size)
        nameLabel?.isEditable = false
        super.init(frame: frameRect)
        updateSize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateSize() {
        self.setFrameSize(NSSize(width: CGFloat(object.endFrame - object.startFrame), height: 30))
    }
    
    override func draw(_ dirtyRect: NSRect) {
        updateSize()
        
        let gradient = NSGradient(colors: [.blue, .black])
        gradient?.draw(in: dirtyRect, angle: 0)
        
        super.draw(dirtyRect)
    }
    
    override func mouseDown(with event: NSEvent) {
        startPos = event.locationInWindow
        
        if event.modifierFlags.contains(.shift) {
            delegate?.deselctObject(object)
        }
        delegate?.selectObject(object)
    }
    
    override func mouseDragged(with event: NSEvent) {
        let diffX = event.locationInWindow.x - 80 - startPos.x
        if diffX > 0 {
            // if dragged to right
            self.frame.origin.x = event.locationInWindow.x - 80
        }
        if diffX <= 0 {
            // if dragged to left
            if self.frame.origin.x + diffX <= 0 {
                self.frame.origin.x = 0
            } else {
                self.frame.origin.x = event.locationInWindow.x - 80
            }
        }
        if event.locationInWindow.y > startPos.y {
            // if dragged to up
            
        }
        if event.locationInWindow.y < startPos.y {
            // if dragged to down
            
        }
        
        self.needsDisplay = true
    }
    
    override func mouseUp(with event: NSEvent) {
        let diff = event.locationInWindow.x - startPos.x
        if diff > 0 && self.frame.maxX == self.superview?.frame.width {
            self.superview?.frame.size.width += diff
        }
        
        delegate?.updateTLLayerObject(view: self, object: object)
    }
    
    override func menu(for event: NSEvent) -> NSMenu? {
        let menu = NSMenu(title: "")
        
        menu.addItem(withTitle: "Delete", action: #selector(delegate?.deleteObject(_:)), keyEquivalent: String.init(format: "%c", 0x7f))
        
        return menu
    }
}
