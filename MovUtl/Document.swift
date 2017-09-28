import Cocoa
import AudioUnit
import AVFoundation

class Document: NSDocument {
    var mainWindow : MainWindowController!
    
    var data: ProjectData
    
    @IBAction func addMediaObject(_ sender:NSMenuItem) {
        let vc = (mainWindow.contentViewController as! ViewController)
        
        let newData = MediaObject()
        newData.endFrame = 60
        let newFilter = Filter(type:.base, object: newData)
        newFilter.name = "Base Component"
        newData.filters.append(newFilter)
        
        switch sender.title {
            case "Text":
            let comSize = ValueComponent()
            comSize.maxValue = 100.0
            comSize.initValue = 30.0
            comSize.name = "Size"
            newData.filters[0].componentProperties.append(comSize)
            
            let comFontColor = ColorComponent()
            comFontColor.initColor = .white
            comFontColor.name = "Font Color"
            newData.filters[0].componentProperties.append(comFontColor)
            
            let comBackColor = ColorComponent()
            comBackColor.initColor = .black
            comBackColor.name = "Background Color"
            newData.filters[0].componentProperties.append(comBackColor)
            
            let comText = TextComponent()
            newData.filters[0].componentProperties.append(comText)
            
            default: break
        }
        
        data.objects.append(newData)
        
        let newObject = TimeLineLayerObjectView(referencingObject: newData, frameRect: NSRect(x: 80 + CGFloat(data.currentFrame), y: 0, width: 100, height: 30))
        newObject.delegate = vc
        
        vc.layerLineContentsViews[0].addSubview(newObject)
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

