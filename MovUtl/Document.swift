import Cocoa
import AudioUnit
import AVFoundation

class Document: NSDocument {
    var mainWindow : MainWindowController!
    
    var data: ProjectData
    
    func updateDocument() {
        mainWindow.document = self
        mainWindow.updateDocument()
    }
    
    @IBAction func addMediaObject(_ sender:NSMenuItem) {
        let newObj = MediaObject()
        newObj.startFrame = data.currentFrame
        newObj.endFrame = data.currentFrame + 180
        
        data.objects.append(newObj)
        updateDocument()
    }
    
    @IBAction func addFilterObject(_ sender:NSMenuItem) {
        
    }
    
    @IBAction func addAudioObject(_ sender:NSMenuItem) {
        
    }
        
    override func read(from url: URL, ofType typeName: String) throws {
        do {
            let textBuffer = try String(contentsOf: url, encoding: .utf8)
            
            for i in 0..<textBuffer.components(separatedBy: ";").count {
                let object = TimeLineObject()
                
                let depth = Int(textBuffer.components(separatedBy: ";")[i].components(separatedBy: ":")[1])!
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
                object.useCameraControll = Bool(textBuffer.components(separatedBy: ";")[i + 8].components(separatedBy: ":")[1])!
                object.useClipping = Bool(textBuffer.components(separatedBy: ";")[i + 9].components(separatedBy: ":")[1])!
                object.useMouseMoving = Bool(textBuffer.components(separatedBy: ";")[i + 10].components(separatedBy: ":")[1])!
                object.isEnabled = Bool(textBuffer.components(separatedBy: ";")[i + 11].components(separatedBy: ":")[1])!
                object.referencingFile = textBuffer.components(separatedBy: ";")[i + 12].components(separatedBy: ":")[1]
                    
                object.layerDepth = depth
                data.objects.append(object)
                
            }
        } catch {
            Swift.print("Error to load the file.")
            data.objects = []
        }
    }
    
    override func write(to url: URL, ofType typeName: String) throws {
        do {
            for object in data.objects {
                try "Layer:\(object.layerDepth);".write(to: url, atomically: true, encoding: .utf8)
                try "StartFrame:\(object.startFrame);".write(to: url, atomically: true, encoding: .utf8)
                try "EndFrame:\(object.endFrame);".write(to: url, atomically: true, encoding: .utf8)
                try "Name:\(object.name);".write(to: url, atomically: true, encoding: .utf8)
                try "FirstColorR:\(object.firstColor.components?[0] ?? 0);".write(to: url, atomically: true, encoding: .utf8)
                try "FirstColorG:\(object.firstColor.components?[1] ?? 0);".write(to: url, atomically: true, encoding: .utf8)
                try "FirstColorB:\(object.firstColor.components?[2] ?? 0);".write(to: url, atomically: true, encoding: .utf8)
                try "SecondColorR:\(object.secondColor.components?[0] ?? 0);".write(to: url, atomically: true, encoding: .utf8)
                try "SecondColorG:\(object.secondColor.components?[1] ?? 0);".write(to: url, atomically: true, encoding: .utf8)
                try "SecondColorB:\(object.secondColor.components?[2] ?? 0);".write(to: url, atomically: true, encoding: .utf8)
                try "UseCameraControll:\(object.useCameraControll);".write(to: url, atomically: true, encoding: .utf8)
                try "UseClipping:\(object.useClipping);".write(to: url, atomically: true, encoding: .utf8)
                try "UseMouseMoving:\(object.useMouseMoving);".write(to: url, atomically: true, encoding: .utf8)
                try "IsEnabled:\(object.isEnabled);".write(to: url, atomically: true, encoding: .utf8)
                try "ReferencingFile:\(object.referencingFile);".write(to: url, atomically: true, encoding: .utf8)
            }
            
        } catch {
            Swift.print("Error to save the file.")
        }
    }
    
    override init() {
        data = ProjectData()
        var audioComponentDescription = AudioComponentDescription(componentType: kAudioUnitType_Output, componentSubType: kAudioUnitSubType_HALOutput, componentManufacturer: kAudioUnitManufacturer_Apple, componentFlags: 0, componentFlagsMask: 0)
        if let audioComponent = AudioComponentFindNext(nil, &audioComponentDescription) {
            
            AudioComponentInstanceNew(audioComponent, &(data.audioUnit))
            AudioUnitInitialize(data.audioUnit!)
            
            let audioFormat = AVAudioFormat(standardFormatWithSampleRate: data.audioSampleRate, channels: 2)
            var asbDescription = audioFormat.streamDescription.pointee
            AudioUnitSetProperty(data.audioUnit!, kAudioUnitProperty_StreamFormat, kAudioUnitScope_Input, 0, &asbDescription, UInt32(MemoryLayout.size(ofValue: asbDescription)))
        }
        super.init()
    }
    
    override func makeWindowControllers() {
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        mainWindow = storyboard.instantiateController(withIdentifier: "Main Window") as! MainWindowController
        mainWindow.document = self
        addWindowController(mainWindow)
        mainWindow.showWindow(nil)
    }
    
    
    override class func autosavesInPlace() -> Bool {
        return true
    }
}

