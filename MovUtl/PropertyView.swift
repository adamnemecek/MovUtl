import Cocoa

class FlippedView : NSView {
    override var isFlipped: Bool {
        get {
            return true
        }
    }
}

@objc protocol PropertyViewDelegate {
    func pushedEnable(_:Any)
    func pushedIn3D(_:Any)
    func pushedReset(_:Any)
    func pushedModeChange(_:Any)
    
    func editStartFrame(_:UInt64)
    func editEndFrame(_:UInt64)
}

class PropertyView : NSView {
    @IBOutlet weak var enableButton : NSButton?
    @IBOutlet weak var startFrameNumField : NSTextField?
    @IBOutlet weak var endFrameNumField : NSTextField?
    @IBOutlet weak var ratioBarView : PropertyRatioView?
    
    weak var delegate : PropertyViewDelegate?
    
    @IBAction func pushEnable(_ sender: NSButton) {
        if enableButton?.image?.name() == NSImage.Name.statusAvailable {
            enableButton?.image = NSImage(named: NSImage.Name.statusUnavailable)
        } else {
            enableButton?.image = NSImage(named: NSImage.Name.statusAvailable)
        }
        
        delegate?.pushedEnable(sender)
    }
    
    @IBAction func editStartFrameField(_ sender: Any) {
        if let value = startFrameNumField?.intValue {
            if value > 0 {
                delegate?.editStartFrame(UInt64(bitPattern: Int64(value)))
            }
        }
    }
    
    @IBAction func editEndFrameField(_ sender: Any) {
        if let value = endFrameNumField?.intValue {
            if value > 0 {
                delegate?.editEndFrame(UInt64(bitPattern: Int64(value)))
            }
        }
    }
}

class PropertyRatioView : NSView {
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
        NSGradient(starting: .blue, ending: .black)?.draw(in: dirtyRect, angle: 0)
        
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
    
    override var isFlipped: Bool {
        get {
            return true
        }
    }
    
    func updateComponentsView(objects:[TimeLineObject])  {
        for object in objects {
            for filter in object.filters {
                var viewArray : NSArray? = NSArray()
                Bundle.main.loadNibNamed(NSNib.Name(rawValue: "PropertyContainerView"), owner: self, topLevelObjects: &viewArray)
                for container in viewArray! {
                    if let filterView = container as? PropertyContainerView {
                        
                        filterView.filterLabel.stringValue = filter.name
                        
                        var pCount = 0
                        for property in filter.componentProperties {
                            
                            if let bProperty = property as? BoolComponent {
                                
                            } else if let cProperty = property as? ColorComponent {
                                
                            } else if let tProperty = property as? TextComponent {
                                
                            } else if let fProperty = property as? FileComponent {
                                
                            } else if let vProperty = property as? ValueComponent {
                                var viewArray : NSArray? = NSArray()
                                Bundle.main.loadNibNamed(NSNib.Name(rawValue: "PropertyValueView"), owner: self, topLevelObjects: &viewArray)
                                for view in viewArray! {
                                    if view is PropertyValueView {
                                        let propertyView = view as! PropertyValueView
                                        propertyView.wantsLayer = true
                                        propertyView.layer?.borderWidth = 0.1
                                        propertyView.layer?.borderColor = .black
                                        propertyView.layer?.backgroundColor = CGColor(gray: 0.8, alpha: 0.8)
                                        
                                        propertyView.slider.minValue = vProperty.minValue
                                        propertyView.slider.maxValue = vProperty.maxValue
                                        propertyView.slider.doubleValue = vProperty.initValue
                                        
                                        propertyView.edittableValue.doubleValue = vProperty.initValue
                                        
                                        propertyView.bvcButton.title = vProperty.name
                                        
                                        propertyView.component = vProperty
                                        
                                        propertyView.frame = NSRect(x: 0, y: pCount + 20, width: 270, height: 40)
                                        
                                        filterView.addSubview(propertyView)
                                        pCount += 40
                                    }
                                }
                            }
                        }
                        addSubview(filterView)
                    }
                }
                
            }
        }
    }
}

class PropertyContainerView : FlippedView {
    @IBOutlet var disclosure: NSButton!
    @IBOutlet var filterLabel: NSTextField!
    
    @IBAction func openProperties(_ sender: NSButton) {
        
    }
}

class PropertyValueView : NSView {
    @IBOutlet var slider: NSSlider!
    @IBOutlet var edittableValue: NSTextField!
    @IBOutlet var bvcButton: NSButton!
    
    var wc : NSWindowController?
    var bvc : PropertyBezierValueControllerWindow?
    
    var component : ValueComponent?
    
    @IBAction func slide(_ sender:Any) {
        edittableValue.doubleValue = slider.doubleValue
        bvc?.startValueView.doubleValue = slider.doubleValue
    }
    
    @IBAction func setText(_ sender: Any) {
        slider.doubleValue = edittableValue.doubleValue
        bvc?.startValueView.doubleValue = edittableValue.doubleValue
    }
    
    @IBAction func pushBVCButton(_ sender: NSButton) {
        var array : NSArray? = NSArray()
        Bundle.main.loadNibNamed(NSNib.Name(rawValue: "PropertyBezierValueControllerWindow"), owner: self.window?.contentViewController, topLevelObjects: &array)
        for window in array! {
            if let bvcW = window as? PropertyBezierValueControllerWindow {
                bvc = bvcW
                bvc?.component = component
                wc = NSWindowController(window: bvc)
                wc?.showWindow(sender)
            }
        }
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
    
    var component : ValueComponent? {
        didSet {
            startValueView.doubleValue = (component?.currentValue)!
            lastValueField.doubleValue = (component?.bvcEndValue)!
            self.title = (component?.name)!
            bvc.component = self.component
        }
    }
    
    @IBAction func editLastValue(_ sender: Any) {
        component?.bvcEndValue = lastValueField.doubleValue
    }
}

class BVCView : NSView {
    var controlP1 : NSPoint = NSPoint(x: 100, y: 0)
    var controlP2 : NSPoint = NSPoint(x: 100, y: 200)
    
    var component : ValueComponent?
    
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
        NSColor.red.setStroke()
        let path = NSBezierPath()
        path.move(to: NSPoint(x: 0, y: 0))
        path.curve(to: NSPoint(x: 200, y: 200), controlPoint1: controlP1, controlPoint2: controlP2)
        path.stroke()
        
        //Render control point
        NSColor.green.setFill()
        
        let cp1Dot = NSBezierPath()
        cp1Dot.appendOval(in: NSRect(x: controlP1.x - 5.0, y: controlP1.y - 5.0, width: 10, height: 10))
        cp1Dot.fill()
        NSBezierPath.strokeLine(from: .zero, to: controlP1)
        
        let cp2Dot = NSBezierPath()
        cp2Dot.appendOval(in: NSRect(x: controlP2.x - 5.0, y: controlP2.y - 5.0, width: 10, height: 10))
        cp2Dot.fill()
        NSBezierPath.strokeLine(from: NSPoint(x: 200, y: 200), to: controlP2)
        
    }
    
    var isControlPointMoving = 0
    
    override func mouseDown(with event: NSEvent) {
        let mousePos = NSPoint(x: event.locationInWindow.x - 40, y: event.locationInWindow.y)
        if NSPointInRect(mousePos, NSRect(x: controlP1.x - 5.0, y: controlP1.y - 5.0, width: 10, height: 10)) {
            isControlPointMoving = 1
        } else if NSPointInRect(mousePos, NSRect(x: controlP2.x - 5.0, y: controlP2.y - 5.0, width: 10, height: 10)) {
            isControlPointMoving = 2
        } else {
            isControlPointMoving = 0
        }
    }
    
    override func mouseDragged(with event: NSEvent) {
        let mousePos = NSPoint(x: event.locationInWindow.x - 40, y: event.locationInWindow.y)
        switch isControlPointMoving {
        case 1:
            component?.bvcControlPoint1 = mousePos
            controlP1 = mousePos
            needsDisplay = true
        case 2:
            component?.bvcControlPoint2 = mousePos
            controlP2 = mousePos
            needsDisplay = true
        default: break
        }
    }
}
