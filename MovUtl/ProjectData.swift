import Cocoa
import CoreGraphics
import AudioUnit

class ProjectData: NSObject, NSCoding {
    var width : Int = 1024
    var height : Int = 768
    var objects : [TimeLineObject] = []
    var currentFrame : UInt64 = 0
    var totalFrame : UInt64 = 1800
    var fps : Double = 30.0
    var scale : CGFloat = 1.0
    var audioUnit : AudioUnit?
    var audioSampleRate : Float64 = 44100.0
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(width, forKey: "Width")
        aCoder.encode(height, forKey: "Height")
        aCoder.encode(currentFrame, forKey: "CurrentFrame")
        aCoder.encode(totalFrame, forKey: "TotalFrame")
        aCoder.encode(fps, forKey: "fps")
        aCoder.encode(scale, forKey: "Scale")
        aCoder.encode(audioSampleRate, forKey: "AudioSampleRate")
        
        aCoder.encode(objects.count, forKey: "ObjectsCount")
        for object in objects {
            object.encode(with: aCoder)
        }
    }
    
    override init() {
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        width = aDecoder.decodeInteger(forKey: "Width")
        height = aDecoder.decodeInteger(forKey: "Height")
        currentFrame = UInt64(aDecoder.decodeInt64(forKey: "CurrentFrame"))
        totalFrame = UInt64(aDecoder.decodeInt64(forKey: "TotalFrame"))
        fps = aDecoder.decodeDouble(forKey: "fps")
        scale = CGFloat(aDecoder.decodeDouble(forKey: "Scale"))
        audioSampleRate = aDecoder.decodeDouble(forKey: "AudioSampleRate")
        
        for _ in 0..<aDecoder.decodeInteger(forKey: "ObjectsCount") {
            objects.append(TimeLineObject(coder: aDecoder)!)
        }
    }
}
