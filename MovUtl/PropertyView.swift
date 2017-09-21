import Cocoa

@objc protocol PropertyViewDelegate {
    func pushedEnable(_:Any)
    func pushedIn3D(_:Any)
    func pushedReset(_:Any)
    func pushedModeChange(_:Any)
    
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

class PropertyComponentsView : NSView {
    
}
