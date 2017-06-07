import Cocoa
import AudioUnit
import AVFoundation

class Document: NSDocument {
    var mainWindow : NSWindowController!
    var timeLine : NSWindowController!
    var componentsPanel : NSWindowController!
    
    var isInputed : Bool = false
    var width : Int = 1024
    var height : Int = 768
    var layers : [LayerData] = []
    var currentFrame : UInt64 = 0
    var totalFrame : UInt64 = 1800
    var fps : Double = 30.0
    var scale : CGFloat = 1.0
    var audioUnit : AudioUnit?
    var audioSampleRate : Float64 = 44100.0
    
    override func read(from url: URL, ofType typeName: String) throws {
        do {
            let textBuffer = try String(contentsOf: url, encoding: .utf8)
            
            for i in 0..<textBuffer.components(separatedBy: ";").count {
                let component = textBuffer.components(separatedBy: ";")[i]
                let value = component.components(separatedBy: ":")[i + 1]
                if let depth = Int(value) {
                    let object = TimeLineObject()
                    object.startFrame = UInt64(textBuffer.components(separatedBy: ";")[i + 1].components(separatedBy: ":")[1])!
                    object.endFrame = UInt64(textBuffer.components(separatedBy: ";")[i + 2].components(separatedBy: ":")[1])!
                    object.name = textBuffer.components(separatedBy: ";")[i + 3].components(separatedBy: ":")[1] as NSString
                    let firstColorR = CGFloat(Double(textBuffer.components(separatedBy: ";")[i + 4].components(separatedBy: ":")[1])!)
                    let firstColorG = CGFloat(Double(textBuffer.components(separatedBy: ";")[i + 5].components(separatedBy: ":")[1])!)
                    let firstColorB = CGFloat(Double(textBuffer.components(separatedBy: ";")[i + 6].components(separatedBy: ":")[1])!)
                    object.firstColor = CGColor(red: firstColorR, green: firstColorG, blue: firstColorB, alpha: 0)
                    let secondColorR = CGFloat(Double(textBuffer.components(separatedBy: ";")[i + 4].components(separatedBy: ":")[1])!)
                    let secondColorG = CGFloat(Double(textBuffer.components(separatedBy: ";")[i + 5].components(separatedBy: ":")[1])!)
                    let secondColorB = CGFloat(Double(textBuffer.components(separatedBy: ";")[i + 6].components(separatedBy: ":")[1])!)
                    object.secondColor = CGColor(red: secondColorR, green: secondColorG, blue: secondColorB, alpha: 0)
                    object.layer = CALayer()
                    object.layer?.zPosition = CGFloat(Double(textBuffer.components(separatedBy: ";")[i + 7].components(separatedBy: ":")[1])!)
                    object.useCameraControll = Bool(textBuffer.components(separatedBy: ";")[i + 8].components(separatedBy: ":")[1])!
                    object.useClipping = Bool(textBuffer.components(separatedBy: ";")[i + 9].components(separatedBy: ":")[1])!
                    object.useMouseMoving = Bool(textBuffer.components(separatedBy: ";")[i + 10].components(separatedBy: ":")[1])!
                    object.isEnabled = Bool(textBuffer.components(separatedBy: ";")[i + 11].components(separatedBy: ":")[1])!
                    object.objectType = ObjectType(rawValue: Int(textBuffer.components(separatedBy: ";")[i + 12].components(separatedBy: ":")[1])!)!
                    object.referencingFile = textBuffer.components(separatedBy: ";")[i + 13].components(separatedBy: ":")[1]
                    
                    layers[depth].objects?.append(object)
                }
            }
        } catch {
            Swift.print("Error to load the file.")
            layers = []
        }
    }
    
    override func write(to url: URL, ofType typeName: String) throws {
        do {
            
            for i in 0..<layers.count {
                let layer = layers[i]
                try "Layer:\(i);".write(to: url, atomically: true, encoding: .utf8)
                for object in layer.objects ?? [] {
                    try "StartFrame:\(object.startFrame);".write(to: url, atomically: true, encoding: .utf8)
                    try "EndFrame:\(object.endFrame);".write(to: url, atomically: true, encoding: .utf8)
                    try "Name:\(object.name);".write(to: url, atomically: true, encoding: .utf8)
                    try "FirstColorR:\(object.firstColor.components?[0] ?? 0);".write(to: url, atomically: true, encoding: .utf8)
                    try "FirstColorG:\(object.firstColor.components?[1] ?? 0);".write(to: url, atomically: true, encoding: .utf8)
                    try "FirstColorB:\(object.firstColor.components?[2] ?? 0);".write(to: url, atomically: true, encoding: .utf8)
                    try "SecondColorR:\(object.secondColor.components?[0] ?? 0);".write(to: url, atomically: true, encoding: .utf8)
                    try "SecondColorG:\(object.secondColor.components?[1] ?? 0);".write(to: url, atomically: true, encoding: .utf8)
                    try "SecondColorB:\(object.secondColor.components?[2] ?? 0);".write(to: url, atomically: true, encoding: .utf8)
                    try "LayerDepth:\(object.layer?.zPosition ?? 0);".write(to: url, atomically: true, encoding: .utf8)
                    try "UseCameraControll:\(object.useCameraControll);".write(to: url, atomically: true, encoding: .utf8)
                    try "UseClipping:\(object.useClipping);".write(to: url, atomically: true, encoding: .utf8)
                    try "UseMouseMoving:\(object.useMouseMoving);".write(to: url, atomically: true, encoding: .utf8)
                    try "IsEnabled:\(object.isEnabled);".write(to: url, atomically: true, encoding: .utf8)
                    try "ObjectType:\(object.objectType);".write(to: url, atomically: true, encoding: .utf8)
                    try "ReferencingFile:\(object.referencingFile);".write(to: url, atomically: true, encoding: .utf8)
                }
            }
        } catch {
            Swift.print("Error to save the file.")
        }
    }
    
    override init() {
        super.init()
        var audioComponentDescription = AudioComponentDescription(componentType: kAudioUnitType_Output, componentSubType: kAudioUnitSubType_HALOutput, componentManufacturer: kAudioUnitManufacturer_Apple, componentFlags: 0, componentFlagsMask: 0)
        if let audioComponent = AudioComponentFindNext(nil, &audioComponentDescription) {
            
            AudioComponentInstanceNew(audioComponent, &audioUnit)
            AudioUnitInitialize(audioUnit!)
            
            let audioFormat = AVAudioFormat(standardFormatWithSampleRate: audioSampleRate, channels: 2)
            var asbDescription = audioFormat.streamDescription.pointee
            AudioUnitSetProperty(audioUnit!, kAudioUnitProperty_StreamFormat, kAudioUnitScope_Input, 0, &asbDescription, UInt32(MemoryLayout.size(ofValue: asbDescription)))
        }
    }
    
    override func makeWindowControllers() {
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        mainWindow = storyboard.instantiateController(withIdentifier: "Main Window") as! NSWindowController
        timeLine = storyboard.instantiateController(withIdentifier: "Time Line Window") as! NSWindowController
        mainWindow.document = self
        timeLine.document = self
        componentsPanel.document = self
        _=[mainWindow, timeLine, componentsPanel].map { addWindowController($0) }
        mainWindow.showWindow(nil)
    }
    
    
    override class func autosavesInPlace() -> Bool {
        return true
    }
}

