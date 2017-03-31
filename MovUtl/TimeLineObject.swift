import Cocoa

class TimeLineObject {
    var endFrame: UInt64 = 0
    var startFrame: UInt64 = 0
    var name : NSString = ""
    var firstColor : CGColor = .black
    var secondColor : CGColor = .white
    var layer : CALayer?
    var frame : CGRect = CGRect(x: 0, y: 0, width: 0, height: 0)
    var useCameraControll : Bool = false
    var useClipping : Bool = false
    var useMouseMoving : Bool = false
    var isEnabled : Bool = true
    var objectType : ObjectType = .movie
    var filterType : FilterType = .sceneChange
    var referencingFile: String = ""
    var properties: [Any] = []
    var effectFilters: [FilterType] = []
    var blendMode: CGBlendMode?
}

enum ObjectType: Int {
    case movie = 0
    case audio = 1
    case picture = 2
    case cameraControll = 3
    case oneFilter = 4 // This effect is only on the layer of this object --> One filter
    case audiowave = 5
    case shape = 6
    case text = 7
    case filter = 8
}

enum FilterType: Int {
    case sceneChange = 0
    case colorToneCollection = 1
    case extendedColorToneCollection = 2
    case blur = 3
    case mosaic = 4
    case luminescence = 5
    case diffusedLight = 6
    case grow = 7
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
