import Cocoa

@objc protocol PropertyViewDelegate {
    func pushedEnable(_:Any)
    func pushedIn3D(_:Any)
    func pushedReset(_:Any)
    func pushedModeChange(_:Any)
    
    func editStartFrame(_:Any)
    func editEndFrame(_:Any)
}

class PropertyView : NSView {
    @IBOutlet weak var enableButton : NSButton?
    @IBOutlet weak var startFrameNumField : NSTextField?
    @IBOutlet weak var endFrameNumField : NSTextField?
    @IBOutlet weak var ratioBarView : NSView?
    
    weak var delegate : PropertyViewDelegate?
    
    @IBAction func pushEnable(_ sender: NSButton) {
        if enableButton?.image?.name() == NSImageNameStatusAvailable {
            enableButton?.image = NSImage(named: NSImageNameStatusUnavailable)
        } else {
            enableButton?.image = NSImage(named: NSImageNameStatusAvailable)
        }
        
        delegate?.pushedEnable(sender)
    }
}

@objc protocol PropertyComponentsViewDelegate {
    func viewBezeirValueContoroller(_:Any)
    func editValue(_:Any)
    func addComponent(_:Any)
    func removeComponent(_:Any)
    func exchangeComponentBelow(_:Any)
    func exchangeComponentDown(_:Any)
}

class PropertyComponentsView : NSView {
    weak var delegate : PropertyComponentsViewDelegate?
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
    }
    
    func addComponentView(type:FilterType) {
        
    }
}
