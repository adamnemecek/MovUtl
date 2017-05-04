import Cocoa
import AudioUnit
import AVFoundation

class MovUtlDocument: NSDocument {
    var mainWindow : NSWindowController!
    var timeLine : NSWindowController!
    var componentsPanel : NSWindowController!
    
    var isInputed : Bool = false
    var width : Int = 1024
    var height : Int = 768
    var context : CGContext!
    var layerViews : [LayerView] = []
    var selectingObject : TimeLineObject?
    var currentFrame : UInt64 = 0
    var totalFrame : UInt64 = 1800
    var fps : Double = 30.0
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
                    object.referencingFile = textBuffer.components(separatedBy: ";")[i + 3].components(separatedBy: ":")[1]
                    
                    layerViews[depth].objects?.append(object)
                }
            }
        } catch {
            Swift.print("Error to load the file.")
            layerViews = []
        }
    }
    
    override func data(ofType typeName: String) throws -> Data {
        var data = Data()
        for i in 0..<layerViews.count {
            let layer = layerViews[i]
            data.append("Layer:\(i);".data(using: .utf8)!)
            for object in layer.objects! {
                data.append("StartFrame:\(object.startFrame);".data(using: .utf8)!)
                data.append("EndFrame:\(object.endFrame);".data(using: .utf8)!)
                data.append("Name:\(object.name);".data(using: .utf8)!)
                data.append("FirstColorR:\(object.firstColor.components?[0] ?? 0);".data(using: .utf8)!)
                data.append("FirstColorG:\(object.firstColor.components?[1] ?? 0);".data(using: .utf8)!)
                data.append("FirstColorB:\(object.firstColor.components?[2] ?? 0);".data(using: .utf8)!)
                data.append("SecondColorR:\(object.secondColor.components?[0] ?? 0);".data(using: .utf8)!)
                data.append("SecondColorG:\(object.secondColor.components?[1] ?? 0);".data(using: .utf8)!)
                data.append("SecondColorB:\(object.secondColor.components?[2] ?? 0);".data(using: .utf8)!)
                data.append("LayerDepth:\(object.layer?.zPosition ?? 0);".data(using: .utf8)!)
                data.append("UseCameraControll:\(object.useCameraControll);".data(using: .utf8)!)
                data.append("UseClipping:\(object.useClipping);".data(using: .utf8)!)
                data.append("UseMouseMoving:\(object.useMouseMoving);".data(using: .utf8)!)
                data.append("IsEnabled:\(object.isEnabled);".data(using: .utf8)!)
                data.append("ObjectType:\(object.objectType);".data(using: .utf8)!)
                data.append("ReferencingFile:\(object.referencingFile);".data(using: .utf8)!)
            }
        }
        return data
    }
    
    override init() {
        super.init()
        let bitsPerComponent = Int(CGImageAlphaInfo.premultipliedLast.rawValue)
        context = CGContext(data: nil, width: width, height: height, bitsPerComponent: bitsPerComponent, bytesPerRow: height*bitsPerComponent, space: CGColorSpace(name: CGColorSpace.sRGB)!, bitmapInfo: CGBitmapInfo.floatComponents.rawValue)
        
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
        componentsPanel = storyboard.instantiateController(withIdentifier: "Components Panel") as! NSWindowController
        mainWindow.document = self
        timeLine.document = self
        componentsPanel.document = self
        mainWindow.showWindow(nil)
        timeLine.showWindow(nil)
        componentsPanel.showWindow(nil)
    }
}
