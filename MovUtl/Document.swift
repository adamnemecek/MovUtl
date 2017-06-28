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
        NSKeyedUnarchiver.unarchiveObject(withFile: url.absoluteString)
    }
    
    override func write(to url: URL, ofType typeName: String) throws {
        NSKeyedArchiver.archivedData(withRootObject: data)
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

