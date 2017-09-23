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
    
    init(frame frameRect:NSRect, objects:[TimeLineObject])  {
        super.init(frame: frameRect)
        
        for object in objects {
            for filter in object.filters {
                let filterView = NSView(frame: NSRect(x: 480, y: 0, width: 270, height: 280))
                    
                for property in filter.componentProperties {
                    if property.initValue is Bool {
                        
                    } else if property.initValue is NSColor {
                        
                    } else if property.initValue is String {
                        
                    } else if property.initValue is Bundle {
                        
                    } else {
                        let propertyView = PropertyValueView(frame: NSRect(x: 480, y: 0, width: 270, height: 40))
                        propertyView.wantsLayer = true
                        propertyView.layer?.borderWidth = 0.2
                        propertyView.layer?.borderColor = CGColor(gray: 0.5, alpha: 1.0)
                        
                        filterView.addSubview(propertyView)
                    }
                }
                addSubview(filterView)
            }
        }
    }
    
    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
        
    }
}

class PropertyValueView : NSView {
    @IBOutlet var slider: NSSlider!
    @IBOutlet var edittableValue: NSTextField!
    @IBOutlet var bvcButton: NSButton!
    
    @IBAction func slide(_ sender:Any) {
        
    }
}

class PropertyColorView : NSView {
    @IBOutlet var colorWell: NSColorWell!
    
}

class PropertyFileReferenceView : NSView {
    @IBOutlet var openButton: NSButton!
    @IBOutlet var fileName: NSTextField!
    
}

class PropertyTextFieldView : NSView {
    @IBOutlet var textField: NSScrollView!
    
}

class PropertyCheckboxView: NSView {
    @IBOutlet var checkbox: NSButton!
    
}

class PropertyBezeirValueControllerWindow : NSWindow {
    @IBOutlet var lastValueField: NSTextField!
    @IBOutlet var startValueView: NSTextField!
    @IBOutlet weak var bvc: BVCView!
    
}

class BVCView : NSView {
    var controllP1 : NSPoint = .zero
    var controllP2 : NSPoint = .zero
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
        //Render background
        
        
        //Render bezeir curve
        
        
        //Render controll point
        
        
    }
}
