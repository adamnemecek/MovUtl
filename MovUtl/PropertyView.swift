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
    
    func addComponentView(type:Component) {
        
    }
}

class PropertyBaseView : NSView {
    var component : Component
    
    
    init(reference:Component, rect frameRect:NSRect) {
        component = reference
        
        super.init(frame: frameRect)
    }
    
    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class PropertyValueView : PropertyBaseView {
    @IBOutlet var slider: NSSlider!
    @IBOutlet var edittableValue: NSTextField!
    @IBOutlet var bvcButton: NSButton!
    
    @IBAction func slide(_ sender:Any) {
        
    }
}

class PropertyColorView : PropertyBaseView {
    @IBOutlet var colorWell: NSColorWell!
    
}

class PropertyFileReferenceView : PropertyBaseView {
    @IBOutlet var openButton: NSButton!
    @IBOutlet var fileName: NSTextField!
    
}

class PropertyTextFieldView : PropertyBaseView {
    @IBOutlet var textField: NSScrollView!
    
}

class PropertyCheckboxView: PropertyBaseView {
    @IBOutlet var checkbox: NSButton!
    
}

class PropertyBezeirValueControllerWindow : NSWindow {
    @IBOutlet var lastValueField: NSTextField!
    @IBOutlet var startValueView: NSTextField!
    @IBOutlet weak var bvc: BVCView!
    
}

class BVCView : NSView {
    
}
