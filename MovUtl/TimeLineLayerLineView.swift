import Cocoa

class TimeLineLayerLineView: NSView {
    var headerView: TimeLineLayerLineHeaderView!
    var contentsView: NSView!
    
    init(id: Int, frame frameRect: NSRect) {
        headerView = TimeLineLayerLineHeaderView(id: id, frame: NSRect(origin: frameRect.origin, size: CGSize(width: 80, height: frameRect.size.height)))
        headerView.wantsLayer = true
        headerView.layer?.borderWidth = 1.0
        headerView.layer?.borderColor = CGColor.black
        headerView.layer?.backgroundColor = CGColor.init(gray: 0.8, alpha: 1.0)
        contentsView = NSView(frame: NSRect(origin: NSPoint(x: frameRect.origin.x + headerView.frame.size.width, y: frameRect.origin.y), size: frameRect.size))
        
        super.init(frame: frameRect)
        
        addSubview(headerView)
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
    func moveObjectBack(_:TimeLineObject)
    func moveObjectNext(_:TimeLineObject)
    func objectLayerBack(_:TimeLineObject)
    func objectLayerNext(_:TimeLineObject)
    func selectObject(_:TimeLineObject)
    func deselctObject(_:TimeLineObject)
    func updateMovieEnd(_:TimeLineObject)
    func moveObjectTo(_:TimeLineObject)
    func changeLength(_:TimeLineObject)
    func deleteObject(_:TimeLineObject)
}

class TimeLineLayerObjectView: NSView {
    var startPos: NSPoint = NSPoint.zero
    var object: TimeLineObject
    
    weak var delegate: TimeLineLayerObjectViewDelegate?
    
    var nameLabel: NSTextField?
    
    init(referencingObject: TimeLineObject, frameRect: NSRect) {
        object = referencingObject
        super.init(frame: frameRect)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ dirtyRect: NSRect) {
        let gradient = NSGradient(colors: [.blue, .black])
        gradient?.draw(in: dirtyRect, angle: 0)
    }
    
    override func mouseDown(with event: NSEvent) {
        startPos = event.locationInWindow
        
        if event.modifierFlags.contains(.shift) {
            delegate?.deselctObject(object)
        }
        delegate?.selectObject(object)
    }
    
    override func mouseDragged(with event: NSEvent) {
        if event.locationInWindow.x > startPos.x {
            // if dragged to right
            delegate?.moveObjectNext(object)
        }
        if event.locationInWindow.x < startPos.x {
            // if dragged to left
            delegate?.moveObjectBack(object)
        }
        if event.locationInWindow.y > startPos.y {
            // if dragged to up
            delegate?.objectLayerBack(object)
        }
        if event.locationInWindow.y < startPos.y {
            // if dragged to down
            delegate?.objectLayerNext(object)
        }
    }
    
    override func mouseUp(with event: NSEvent) {
        delegate?.updateMovieEnd(object)
    }
    
    override func menu(for event: NSEvent) -> NSMenu? {
        let menu = NSMenu(title: "")
        
        menu.addItem(withTitle: "Move To...", action: #selector(delegate?.moveObjectTo(_:)), keyEquivalent: "")
        menu.addItem(withTitle: "Change Length...", action: #selector(delegate?.changeLength(_:)), keyEquivalent: "")
        menu.addItem(withTitle: "Delete", action: #selector(delegate?.deleteObject(_:)), keyEquivalent: String.init(format: "%c", 0x7f))
        
        return menu
    }
}
