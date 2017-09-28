import Cocoa
import CoreGraphics
import AVFoundation

class TimeLineObject: NSObject, NSCoding {
    var endFrame: UInt64 = 0
    var startFrame: UInt64 = 0
    var layerDepth: Int = 0
    var name : String = ""
    var firstColor : CGColor = .black
    var secondColor : CGColor = .white
    var layer : CGLayer?
    var frame : CGRect = CGRect(x: 0, y: 0, width: 60, height: 30)
    var useCameraControll : Bool = false
    var useClipping : Bool = false
    var useMouseMoving : Bool = false
    var isEnabled : Bool = true
    var referencingFile: String = ""
    var filters : [Filter] = []
    var blendMode: CGBlendMode = .normal
    var alpha: CGFloat = 0.0
    
    func render(at present:UInt64) {
        
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(layerDepth, forKey: "Layer")
        aCoder.encode(startFrame, forKey: "StartFrame")
        aCoder.encode(endFrame, forKey: "EndFrame")
        aCoder.encode(name, forKey: "Name")
        aCoder.encode(firstColor, forKey: "FirstColor")
        aCoder.encode(secondColor, forKey: "SecondColor")
        aCoder.encode(frame, forKey: "Frame")
        aCoder.encode(useCameraControll, forKey: "CameraControll")
        aCoder.encode(useClipping, forKey: "Clipping")
        aCoder.encode(useMouseMoving, forKey: "MouseMoving")
        aCoder.encode(isEnabled, forKey: "Enabled")
        aCoder.encode(referencingFile, forKey: "ReferencingFile")
        aCoder.encode(alpha, forKey: "Alpha")
        aCoder.encode(blendMode, forKey: "BlendMode")
    }
    
    override init() {
        super.init()
    }
    
    required init?(coder decoder:NSCoder) {
        layerDepth = decoder.decodeInteger(forKey: "Layer")
        startFrame = UInt64(decoder.decodeInt64(forKey: "StartFrame"))
        endFrame = UInt64(decoder.decodeInt64(forKey: "EndFrame"))
        name = decoder.decodeObject(forKey: "Name") as! String
        firstColor = decoder.decodeObject(forKey: "FirstColor") as! CGColor
        secondColor = decoder.decodeObject(forKey: "SecondColor") as! CGColor
        frame = decoder.decodeRect(forKey: "Frame")
        useCameraControll = decoder.decodeBool(forKey: "CameraControll")
        useClipping = decoder.decodeBool(forKey: "Clipping")
        useMouseMoving = decoder.decodeBool(forKey: "MouseMoving")
        isEnabled = decoder.decodeBool(forKey: "Enabled")
        referencingFile = decoder.decodeObject(forKey: "ReferencingFile") as! String
        alpha = CGFloat(decoder.decodeDouble(forKey: "Alpha"))
        blendMode = CGBlendMode(rawValue: decoder.decodeInt32(forKey: "BlendMode"))!
    }
}

class MediaObject: TimeLineObject {
    var objectType: MediaObjectType = .test
    
    var samples: [CMSampleBuffer] = []
    
    override func render(at present: UInt64) {
        switch objectType {
        case .test:
            //Test
            glColor3d(0.8, 0.8, 0.8)
            glBegin(GLenum(GL_TRIANGLES))
            
            glVertex2d(-0.5, 0)
            glVertex2d(0.5, -1.0)
            glVertex2d(0.5, 1.0)
            
            glEnd()
            
            glRotated(360.0 * GLdouble(present - startFrame), 1, 0, 0)
        default:
            break
        }
    }
}

class AudioObject: TimeLineObject {
    
}

class FilterObject: TimeLineObject {
    override func render(at present: UInt64) {
        // TODO
        
    }
}

class Filter {
    var name : String = "Test"
    var componentProperties : [Component] = []
    var parentObject : TimeLineObject?
    
    init(type:FilterType, object:TimeLineObject) {
        let testV = ValueComponent()
        testV.maxValue = 10.0
        testV.initValue = 5.0
        testV.name = "X"
        componentProperties.append(testV)
        
        let testV2 = ValueComponent()
        testV2.maxValue = 100.0
        testV2.initValue = 20.0
        testV2.name = "Y"
        componentProperties.append(testV2)
    }
    
    func render(at present:UInt64, buffer:CVPixelBuffer?) {
        
    }
}

class Component {
    
}

class ValueComponent : Component {
    var minValue : Double = 0.0
    var maxValue : Double = 0.0
    var initValue : Double = 0.0 {
        didSet {
            currentValue = initValue
        }
    }
    var currentValue : Double = 0.0
    var name : String = ""
    
    var bvcControlPoint1 : NSPoint = .zero
    var bvcControlPoint2 : NSPoint = NSPoint(x: 200, y: 200)
    var bvcEndValue : Double = 0.0
    
    func valueOfBezier(ratio: Double) -> Double {
        let minusAmountRatio = 1 - ratio
        let b1 = 3*minusAmountRatio*minusAmountRatio*Double(bvcControlPoint1.y / 200)
        let b2 = 3*minusAmountRatio*ratio*ratio*Double(bvcControlPoint2.y / 200)
        let b3 = ratio*ratio*ratio*bvcEndValue
        return b1 + b2 + b3
    }
}

class BoolComponent : Component {
    var initValue : Bool = false {
        didSet {
            currentValue = initValue
        }
    }
    var currentValue : Bool = false
}

class ColorComponent : Component {
    var initColor : NSColor = .white {
        didSet {
            currentColor = initColor
        }
    }
    var currentColor : NSColor = .white
}

class FileComponent : Component {
    var initBundle : Bundle? {
        didSet {
            currentBundle = initBundle
        }
    }
    var currentBundle : Bundle?
}

class TextComponent : Component {
    var initString : String = "" {
        didSet {
            currentString = initString
        }
    }
    var currentString : String = ""
}

enum MediaObjectType: Int {
    case test = -1
    case movie = 0
    case scene = 1 // Without sound
    case picture = 2
    case cameraControll = 3
    case oneFilter = 4 // This effect is only on the layer of this object --> One filter
    case audiowave = 5
    case shape = 6
    case text = 7
    case frameBuffer = 8
    case oneFrameBuffer = 9 // This effect is only on the layer of this object --> One frame buffer
}

enum AudioObjectType: Int {
    case sound = 0
    case sceneSound = 1
}

enum FilterType: Int {
    case test = -1
    case sceneChange = 0
    case colorToneCollection = 1
    case extendedColorToneCollection = 2
    case blur = 3
    case mosaic = 4
    case luminescence = 5
    case diffusedLight = 6
    case glow = 7
    case radiationBlur = 8
    case directionBlur = 9
    case lensBlur = 10
    case motionBlur = 11
    case vibration = 12
    case flip = 13
    case raster = 14
    case imageLoop = 15
    case colorShift = 16
    case monochromatization = 17
    case colorSetting = 18
    case partialFilter = 19
    case audioDelay = 20
    case noiseReduction = 21
    case simpleSharp = 22
    case simpleBlur = 23
    case clipAndResize = 24
    case edgeFill = 25
    case volumeControll = 26
}

enum SceneChangeType: Int {
    case crossFade = 0
    case circleWipe = 1
    case rectWipe = 2
    case clockWipe = 3
    case slice = 4
    case swap = 5
    case slide = 6
    case minimizeRotate = 7
    case pushHorizonal = 8
    case pushVertical = 9
    case rotateHorizonal = 10
    case rotateVertical = 11
    case cubicRotateHorizonal = 12
    case cubicRotateVertical = 13
    case fadeInOut = 14
    case radiationBlur = 15
    case blur = 16
    case wipeHorizonal = 17
    case wipeVertical = 18
    case rollHorizonal = 19
    case rollVertical = 20
    case randomLine = 21
    case grow = 22
    case lensBlur = 23
    case door = 24
    case wakeUp = 25
    case reelRotate = 26
    case shapeWipe = 27
    case hidingShapeWipe = 28
    case radiationHidingShapeWipe = 29
    case clush = 30
    case rollPage = 31
}
