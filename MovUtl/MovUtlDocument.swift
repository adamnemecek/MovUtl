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
    var currentFrame : UInt64 = 0
    var fps : Double = 30.0
    var audioUnit : AudioUnit?
    var audioSampleRate : Double = 44100.0
    
    override func read(from data: Data, ofType typeName: String) throws {
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
                data.append("FirstColorR:\(object.firstColor.redComponent);".data(using: .utf8)!)
                data.append("FirstColorG:\(object.firstColor.greenComponent);".data(using: .utf8)!)
                data.append("FirstColorB:\(object.firstColor.blueComponent);".data(using: .utf8)!)
                data.append("SecondColorR:\(object.secondColor.redComponent);".data(using: .utf8)!)
                data.append("SecondColorG:\(object.secondColor.greenComponent);".data(using: .utf8)!)
                data.append("SecondColorB:\(object.secondColor.blueComponent);".data(using: .utf8)!)
                data.append("UseCameraControll:\(object.useCameraControll);".data(using: .utf8)!)
                data.append("UseClipping:\(object.useClipping);".data(using: .utf8)!)
                data.append("UseMouseMoving:\(object.useMouseMoving);".data(using: .utf8)!)
                data.append("IsEnabled:\(object.isEnabled);".data(using: .utf8)!)
                data.append("LayerDepth:\(object.layer?.zPosition);".data(using: .utf8)!)
                data.append("ObjectType:\(object.objectType);".data(using: .utf8)!)
                data.append("ReferencingFile:\(object.referencingFile);".data(using: .utf8)!)
            }
        }
        return data
    }
    
    override init() {
        super.init()
        let newProjectController = NSWindowController(windowNibName: "NewProjectWindow")
        newProjectController.showWindow(nil)
        while !isInputed {
        }
        
        let bitsPerComponent = Int(CGImageAlphaInfo.premultipliedLast.rawValue)
        context = CGContext(data: nil, width: width, height: height, bitsPerComponent: bitsPerComponent, bytesPerRow: height*bitsPerComponent, space: CGColorSpace(name: CGColorSpace.sRGB)!, bitmapInfo: CGBitmapInfo.floatComponents.rawValue)
        
        var audioComponentDescription = AudioComponentDescription(componentType: kAudioUnitType_Output, componentSubType: kAudioUnitSubType_HALOutput, componentManufacturer: kAudioUnitManufacturer_Apple, componentFlags: 0, componentFlagsMask: 0)
        let audioComponent = AudioComponentFindNext(nil, &audioComponentDescription)
        
        AudioComponentInstanceNew(audioComponent!, &audioUnit)
        AudioUnitInitialize(audioUnit!)
        
        let audioFormat = AVAudioFormat(standardFormatWithSampleRate: audioSampleRate, channels: 2)
        var asbDescription = audioFormat.streamDescription.pointee
        AudioUnitSetProperty(audioUnit!, kAudioUnitProperty_StreamFormat, kAudioUnitScope_Input, 0, &asbDescription, UInt32(MemoryLayout.size(ofValue: asbDescription)))
    }
    
    override func makeWindowControllers() {
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        mainWindow = storyboard.instantiateController(withIdentifier: "Main Window") as! NSWindowController
        timeLine = storyboard.instantiateController(withIdentifier: "Time Line Window") as! NSWindowController
        componentsPanel = storyboard.instantiateController(withIdentifier: "Components Panel") as! NSWindowController
        mainWindow.showWindow(nil)
        timeLine.showWindow(nil)
        componentsPanel.showWindow(nil)
    }
}
