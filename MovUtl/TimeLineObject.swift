import Cocoa

class TimeLineObject: NSObject {
    var startFrame : UInt64 = 0
    var endFrame : UInt64 = 0;
    var name : NSString = "Untitled"
    var firstColor = NSColor.black, secondColor = NSColor.white
    var useCameraControll, useClipping, useMouseMoving, isEnabled : Bool?
}
