import Cocoa

class TimeLineLayerLineView: NSView {
    @IBOutlet weak var headerView: TimeLineLayerLineHeaderView?
    @IBOutlet weak var contentsView: NSView?
    
    override init(frame frameRect: NSRect) {
        let header = TimeLineLayerLineHeaderView(frame: NSRect(origin: frameRect.origin, size: CGSize(width: 120, height: frameRect.size.height)))
        contentsView = NSView(frame: NSRect(origin: NSPoint(x: frameRect.origin.x + header.frame.size.width, y: frameRect.origin.y), size: frameRect.size))
        
        super.init(frame: frameRect)
        
        if let nib = NSNib(nibNamed: "TimeLineLayerLineView", bundle: Bundle(for: self.classForCoder)) {
            nib.instantiate(withOwner: self, topLevelObjects: nil)
            
        }
        
        addSubview(header)
        addSubview(contentsView!)
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
    @IBOutlet weak var header: NSTextField?
    
    weak var delegate: TimeLineLayerLineHeaderViewDelegate?
    
    override init(frame frameRect: NSRect) {
        header = NSTextField(frame: frameRect)
        super.init(frame: frameRect)
        if let nib = NSNib(nibNamed: "TimeLineLayerLineHeaderView", bundle: Bundle(for: self.classForCoder)) {
            nib.instantiate(withOwner: self, topLevelObjects: nil)
            
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        if let nib = NSNib(nibNamed: "TimeLineLayerLineHeaderView", bundle: Bundle(for: self.classForCoder)) {
            nib.instantiate(withOwner: self, topLevelObjects: nil)
            
        }
    }
    
    override func menu(for event: NSEvent) -> NSMenu? {
        let menu = NSMenu(title: "")
        
        menu.addItem(withTitle: "Insert A Layer Below", action: #selector(delegate?.insertLayer(_:)), keyEquivalent: "")
        menu.addItem(withTitle: "Delete This Layer \(header?.stringValue)", action: #selector(delegate?.deleteLayer(_:)), keyEquivalent: "")
        menu.addItem(withTitle: "Exchange Below", action: #selector(delegate?.exchangeLayerBelow(_:)), keyEquivalent: "")
        menu.addItem(withTitle: "Exchange Down", action: #selector(delegate?.exchangeLayerDown(_:)), keyEquivalent: "")
        
        return menu
    }
}

@objc protocol TimeLineLayerObjectViewDelegate {
    func moveObjectTo(_ sender:Any)
    func changeLength(_ sender:Any)
    func deleteObject(_ sender:Any)
    func changeToGroupObject(_ sender:Any)
}

class TimeLineLayerObjectView: NSView {
    @IBOutlet weak var nameLabel: NSTextField?
    var startPos: NSPoint = NSPoint.zero
    var object: TimeLineObject?
    
    weak var delegate: TimeLineLayerObjectViewDelegate?
    
    init(referencingObject: TimeLineObject, frameRect: NSRect) {
        object = referencingObject
        super.init(frame: frameRect)
        
        if let nib = NSNib(nibNamed: "TimeLineLayerObjectView", bundle: Bundle(for: self.classForCoder)) {
            nib.instantiate(withOwner: self, topLevelObjects: nil)
            
        }
        
        nameLabel?.stringValue = object?.name ?? ""
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
        
        guard let vc = (window?.windowController?.contentViewController as! ViewController?) else {
            return
        }
        
        if event.modifierFlags.contains(.shift) {
            vc.selected = []
        }
        //vc.selected.append(object)
    }
    
    override func mouseDragged(with event: NSEvent) {
        if event.locationInWindow.x > startPos.x && object?.startFrame ?? 0 <= 0 {
            // if dragged to right
            //object.startFrame -= 1
            //object.endFrame -= 1
        }
        if event.locationInWindow.x < startPos.x {
            // if dragged to left
            //object.startFrame += 1
            //object.endFrame += 1
        }
        if event.locationInWindow.y > startPos.y && object?.layerDepth ?? 0 <= 0 {
            // if dragged to up
            //object.layerDepth -= 1
        }
        if event.locationInWindow.y < startPos.y {
            // if dragged to down
            //object.layerDepth += 1
        }
    }
    
    override func mouseUp(with event: NSEvent) {
        guard let doc = window?.windowController?.document as! Document? else {
            return
        }
        
        // Update movie end
        //if doc.data.totalFrame < object.endFrame {
        //    doc.data.totalFrame = object.endFrame
        //}
    }
    
    override func menu(for event: NSEvent) -> NSMenu? {
        let menu = NSMenu(title: "")
        
        menu.addItem(withTitle: "Move To...", action: #selector(delegate?.moveObjectTo(_:)), keyEquivalent: "")
        menu.addItem(withTitle: "Change Length...", action: #selector(delegate?.changeLength(_:)), keyEquivalent: "")
        menu.addItem(withTitle: "Delete", action: #selector(delegate?.deleteObject(_:)), keyEquivalent: "")
        menu.addItem(withTitle: "Change To Group Object", action: #selector(delegate?.changeToGroupObject(_:)), keyEquivalent: "")
        
        return menu
    }
}
