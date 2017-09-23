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
    
    func updateComponentsView(objects:[TimeLineObject])  {
        for object in objects {
            for filter in object.filters {
                let filterView = NSView(frame: NSRect(x: 0, y: 0, width: 270, height: 280))
                filterView.wantsLayer = true
                filterView.layer?.borderColor = .black
                filterView.layer?.borderWidth = 0.2
                    
                for property in filter.componentProperties {
                    if property.initValue is Bool {
                        
                    } else if property.initValue is NSColor {
                        
                    } else if property.initValue is String {
                        
                    } else if property.initValue is Bundle {
                        
                    } else {
                        var viewArray = NSArray()
                        Bundle.main.loadNibNamed("PropertyValueView", owner: self, topLevelObjects: &viewArray)
                        for view in viewArray {
                            if view is PropertyValueView {
                                let propertyView = view as! PropertyValueView
                                propertyView.wantsLayer = true
                                propertyView.layer?.borderWidth = 0.1
                                propertyView.layer?.borderColor = .black
                                propertyView.layer?.backgroundColor = CGColor(gray: 0.8, alpha: 0.8)
                                
                                propertyView.slider.minValue = Double(property.minValue)
                                propertyView.slider.maxValue = Double(property.maxValue)
                                propertyView.slider.doubleValue = Double(property.initValue)
                                
                                filterView.addSubview(propertyView)
                            }
                        }
                    }
                }
                addSubview(filterView)
            }
        }
    }
}

class PropertyValueView : NSView {
    @IBOutlet var slider: NSSlider!
    @IBOutlet var edittableValue: NSTextField!
    @IBOutlet var bvcButton: NSButton!
    
    @IBAction func slide(_ sender:Any) {
        edittableValue.doubleValue = slider.doubleValue
    }
    
    @IBAction func setText(_ sender: Any) {
        slider.doubleValue = edittableValue.doubleValue
    }
    
    @IBAction func pushBVCButton(_ sender: NSButton) {
        let bvcWindowController = NSWindowController(windowNibName: "PropertyBezierValueControllerWindow")
        bvcWindowController.showWindow(sender)
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

class PropertyBezierValueControllerWindow : NSWindow {
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
        NSColor.gray.setStroke()
        for i in 0..<10 {
            NSBezierPath.strokeLine(from: NSPoint(x: i * 20, y: 0), to: NSPoint(x: i * 20, y: 200))
        }
        
        for j in 0..<10 {
            NSBezierPath.strokeLine(from: NSPoint(x: 0, y: j * 20), to: NSPoint(x: 200, y: j * 20))
        }
        
        //Render bezeir curve
        
        
        //Render controll point
        
        
    }
}
