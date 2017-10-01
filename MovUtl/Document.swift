import Cocoa
import AudioUnit
import AVFoundation

class Document: NSDocument {
    var mainWindow : MainWindowController!
    
    var data: ProjectData
    
    @IBAction func addMediaObject(_ sender:NSMenuItem) {
        let panel = NSOpenPanel(contentViewController: mainWindow.window!.contentViewController!)
        let url = panel.urls[0]
        let asset = AVURLAsset(url: url)
        
        let id = data.composition!.unusedTrackID()
        data.composition?.addMutableTrack(withMediaType: .video, preferredTrackID: id)
        do {
            try data.composition?.track(withTrackID: id)?.insertTimeRange(CMTimeRangeMake(kCMTimeZero, asset.duration), of: asset.tracks(withMediaType: .video)[0], at: asset.duration)
        } catch {
        
        }
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
            var asbDescription = audioFormat?.streamDescription.pointee
            AudioUnitSetProperty(data.audioUnit!, kAudioUnitProperty_StreamFormat, kAudioUnitScope_Input, 0, &asbDescription, UInt32(MemoryLayout.size(ofValue: asbDescription)))
        }
        super.init()
    }
    
    override func makeWindowControllers() {
        let storyboard = NSStoryboard(name: NSStoryboard.Name(rawValue: "Main"), bundle: nil)
        mainWindow = storyboard.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "Main Window")) as! MainWindowController
        mainWindow.document = self
        addWindowController(mainWindow)
        mainWindow.showWindow(nil)
    }
}

