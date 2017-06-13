import Cocoa
import CoreGraphics
import AVFoundation

protocol VisibleTimeLineProtocol {
    func updateCGLayer()
}

class TimeLineObject: NSObject, VisibleTimeLineProtocol {
    var endFrame: UInt64 = 0
    var startFrame: UInt64 = 0
    var layerDepth: Int = 0
    var name : NSString = ""
    var firstColor : CGColor = .black
    var secondColor : CGColor = .white
    var layer : CGLayer?
    var frame : CGRect = CGRect(x: 0, y: 0, width: 60, height: 30)
    var useCameraControll : Bool = false
    var useClipping : Bool = false
    var useMouseMoving : Bool = false
    var isEnabled : Bool = true
    var filterType : FilterType = .sceneChange
    var referencingFile: String = ""
    var properties : [Int] = []
    var effectFilters: [FilterType] = []
    var blendMode: CGBlendMode?
    var alpha: CGFloat = 0.0
    
    func updateCGLayer() {
        // TODO
    }
    
    func render(at present:UInt64, buffer:CVPixelBuffer) -> CIImage {
        CVPixelBufferLockBaseAddress(buffer, CVPixelBufferLockFlags(rawValue: CVOptionFlags(0)))
        
        let resultImage = CIImage()
        let context = CGContext(data: CVPixelBufferGetBaseAddress(buffer), width: Int(frame.size.width), height: Int(frame.size.height), bitsPerComponent: 8, bytesPerRow: CVPixelBufferGetBytesPerRow(buffer), space: CGColorSpaceCreateDeviceRGB(), bitmapInfo: CGImageAlphaInfo.premultipliedFirst.rawValue)!
        
        if startFrame <= present && present <= endFrame && layer != nil {
            context.draw(layer!, in: frame)
        }
        
        CVPixelBufferUnlockBaseAddress(buffer, CVPixelBufferLockFlags(rawValue: CVOptionFlags(0)))
        
        context.draw(resultImage.cgImage!, in: frame)
        return resultImage
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
    
    override func render(at present: UInt64, buffer: CVPixelBuffer) -> CIImage {
        switch objectType {
        case .movie:
            let pos = present - startFrame
            let imageBuf = CMSampleBufferGetImageBuffer(samples[Int(pos)])!
            return CIImage(cvImageBuffer: imageBuf)
        default: break
        }
        
        return CIImage()
    }
}

class AudioObject: TimeLineObject {
    
}

class FilterObject: TimeLineObject {
    override func updateCGLayer() {
        // TODO
    }
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
