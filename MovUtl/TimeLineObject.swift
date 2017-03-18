import Cocoa

class TimeLineObject: NSObject {
    var startFrame : UInt64 = 0
    var endFrame : UInt64 = 0;
    var name : NSString = "Untitled"
    var firstColor = NSColor.black, secondColor = NSColor.white
    var useCameraControll, useClipping, useMouseMoving, isEnabled : Bool?
    var layer : CALayer?
    enum ObjectType: Int {
        case movie = 0
        case audio = 1
        case picture = 2
        case controll = 3
        case filter = 4
        case audiowave = 5
        case shape = 6
        case text = 7
    }
    var objectType : ObjectType = .movie
    var referencingFile: String = ""
}
