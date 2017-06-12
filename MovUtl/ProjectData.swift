import Cocoa
import CoreGraphics
import AudioUnit

class ProjectData: NSObject {
    var width : Int = 1024
    var height : Int = 768
    var layers : [LayerData] = []
    var currentFrame : UInt64 = 0
    var totalFrame : UInt64 = 1800
    var fps : Double = 30.0
    var scale : CGFloat = 1.0
    var audioUnit : AudioUnit?
    var audioSampleRate : Float64 = 44100.0
}
