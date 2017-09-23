import Cocoa
import CoreGraphics
import AVFoundation

protocol VisibleTimeLineProtocol {
    func updateCGLayer()
    func render(at present:UInt64) -> CGImage?
}

class TimeLineObject: NSObject, NSCoding, VisibleTimeLineProtocol {
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
    
    func updateCGLayer() {
        // TODO
    }
    
    func render(at present:UInt64) -> CGImage? {
        let buffer: CVPixelBuffer? = nil
        
        
        return nil
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
    var objectType: MediaObjectType = .movie
    
    var samples: [CMSampleBuffer] = []
    
    override func updateCGLayer() {
        switch objectType {
        case .movie:
            let asset = AVAsset(url: URL(fileURLWithPath: referencingFile))
            var reader: AVAssetReader!
            do {
                reader = try AVAssetReader(asset: asset)
            } catch {
                Swift.print(error.localizedDescription)
            }
                
            guard let videoTrack = asset.tracks(withMediaType: AVMediaTypeVideo).first else {
                return
            }
                
            let readerOutputSettings: [String: Any] = [kCVPixelBufferPixelFormatTypeKey as String : Int(kCVPixelFormatType_420YpCbCr8BiPlanarFullRange)]
            let readerOutput = AVAssetReaderTrackOutput(track: videoTrack, outputSettings: readerOutputSettings)
            reader.add(readerOutput)
            reader.startReading()
            
            while let sample = readerOutput.copyNextSampleBuffer() {
                samples.append(sample)
            }
            
        //case .scene:
            // Implemented after beta
            
        case .picture:
            guard let image = CIImage(contentsOf: URL(fileURLWithPath: referencingFile))?.cgImage else {
                return
            }
            
            layer?.context?.draw(image, in: frame)
            
            
        default: break
        }
    }
    
    override func render(at present: UInt64) -> CGImage? {
        switch objectType {
        case .movie:
            let pos = present - startFrame
            let imageBuf = CMSampleBufferGetImageBuffer(samples[Int(pos)])!
            return CIImage(cvImageBuffer: imageBuf).cgImage!
        default: break
        }
        
        return nil
    }
}

class AudioObject: TimeLineObject {
    
}

class FilterObject: TimeLineObject {
    override func updateCGLayer() {
        // TODO
    }
    
    override func render(at present: UInt64) -> CGImage? {
        // TODO
        
        return nil
    }
}

class Filter {
    var componentProperties : [Component] = []
    
    init(type:FilterType) {
        let testV = Component()
        testV.maxValue = 10
        testV.initValue = 5
        componentProperties.append(testV)
    }
    
    func render(at present:UInt64, buffer:CVPixelBuffer?) {
        
    }
}

class Component {
    var minValue : Double = 0
    var maxValue : Double = 0
    var initValue : Double = 0 {
        didSet {
            currentValue = initValue
        }
    }
    var currentValue : Double = 0
}

enum MediaObjectType: Int {
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
