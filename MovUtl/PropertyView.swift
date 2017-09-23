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
        if enableButton?.image?.name() == NSImage.Name.statusAvailable {
            enableButton?.image = NSImage(named: NSImage.Name.statusUnavailable)
        } else {
            enableButton?.image = NSImage(named: NSImage.Name.statusAvailable)
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
                        var viewArray : NSArray? = NSArray()
                        Bundle.main.loadNibNamed(NSNib.Name(rawValue: "PropertyValueView"), owner: self, topLevelObjects: &viewArray)
                        for view in viewArray! {
                            if view is PropertyValueView {
                                let propertyView = view as! PropertyValueView
                                propertyView.wantsLayer = true
                                propertyView.layer?.borderWidth = 0.1
                                propertyView.layer?.borderColor = .black
                                propertyView.layer?.backgroundColor = CGColor(gray: 0.8, alpha: 0.8)
                                
                                propertyView.slider.minValue = property.minValue as! Double
                                propertyView.slider.maxValue = property.maxValue as! Double
                                propertyView.slider.doubleValue = property.initValue as! Double
                                
                                propertyView.edittableValue.doubleValue = property.initValue as! Double
                                
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
    
    var wc : NSWindowController?
    
    @IBAction func slide(_ sender:Any) {
        edittableValue.doubleValue = slider.doubleValue
    }
    
    @IBAction func setText(_ sender: Any) {
        slider.doubleValue = edittableValue.doubleValue
    }
    
    @IBAction func pushBVCButton(_ sender: NSButton) {
        var array : NSArray? = NSArray()
        Bundle.main.loadNibNamed(NSNib.Name(rawValue: "PropertyBezierValueControllerWindow"), owner: self.window?.contentViewController, topLevelObjects: &array)
        for window in array! {
            if window is PropertyBezierValueControllerWindow {
                wc = NSWindowController(window: window as? NSWindow)
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
}

class BVCView : NSView {
    var controlP1 : NSPoint = NSPoint(x: 100, y: 0)
    var controlP2 : NSPoint = NSPoint(x: 100, y: 200)
    
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
            controlP1 = mousePos
            needsDisplay = true
        case 2:
            controlP2 = mousePos
            needsDisplay = true
        default: break
        }
    }
}
