import Cocoa

class TimeLineView : NSScrollView {
    var timeBarX : CGFloat = 0.0
    var pasteBoard : NSPasteboard?
    
    var layerViews : [LayerView]?
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        autohidesScrollers = false
        lineScroll = 40.0
        pageScroll = 40.0
        scrollsDynamically = true
        NSColor.black.set()
        for i in 0..<Int(dirtyRect.height / 40) {
            let fromPoint = CGPoint(x: 0.0, y: CGFloat(40 * i))
            let toPoint = CGPoint(x: self.frame.size.width, y: CGFloat(i * 40))
            NSBezierPath.strokeLine(from: fromPoint, to: toPoint)
        }
        NSColor.red.set()
        NSBezierPath.strokeLine(from: CGPoint(x: timeBarX, y: 0), to: CGPoint(x: timeBarX, y: self.frame.size.height))
        if self.layerViews != nil {
            for view in self.layerViews! {
                if view.layer != nil {
                    for object in view.objects! {
                        let gradient = NSGradient.init(starting: NSColor(cgColor: object.firstColor)!, ending: NSColor(cgColor: object.secondColor)!)
                
                        let attributes = [NSFontAttributeName: NSFont(name: "Helvetica Neue", size: 4.0)!,
                                  NSParagraphStyleAttributeName: NSParagraphStyle.default().mutableCopy()]
                        gradient?.draw(in: dirtyRect, angle: 0)
                        object.name.draw(with: dirtyRect, options: NSStringDrawingOptions.usesFontLeading, attributes: attributes)
                    }
                }
            }
        }
    }
    
    override func menu(for event: NSEvent) -> NSMenu? {
        let menu = NSMenu()
        
        // Make a menu of adding media object
        let addMediaObjectMenu = NSMenu()
        
            let addMovie = NSMenuItem(title: "Movie", action: #selector(self.addMovie(sender:)), keyEquivalent: "")
            addMediaObjectMenu.addItem(addMovie)
            
            let addAudio = NSMenuItem(title: "Audio", action: #selector(self.addAudio(sender:)), keyEquivalent: "")
            addMediaObjectMenu.addItem(addAudio)
        
            let addPicture = NSMenuItem(title: "Picture", action: #selector(self.addPicture(sender:)), keyEquivalent: "")
            addMediaObjectMenu.addItem(addPicture)
        
            let addCameraControll = NSMenuItem(title: "Camera Controll", action: #selector(self.addCameraControll(sender:)), keyEquivalent: "")
            addMediaObjectMenu.addItem(addCameraControll)
        
            let addOneFilter = NSMenuItem(title: "One Filter", action: #selector(self.addOneFilter(sender:)), keyEquivalent: "")
            addMediaObjectMenu.addItem(addOneFilter)
        
            let addAudioWave = NSMenuItem(title: "Audio Wave", action: #selector(self.addAudioWave(sender:)), keyEquivalent: "")
            addMediaObjectMenu.addItem(addAudioWave)
        
            let addShape = NSMenuItem(title: "Shape", action: #selector(self.addShape(sender:)), keyEquivalent: "")
            addMediaObjectMenu.addItem(addShape)
        
            let addText = NSMenuItem(title: "Text", action: #selector(self.addText(sender:)), keyEquivalent: "")
            addMediaObjectMenu.addItem(addText)
        
        let addMediaObject = NSMenuItem(title: "Add Media Object", action: nil, keyEquivalent: "")
        addMediaObject.submenu = addMediaObjectMenu
        menu.addItem(addMediaObject)
        
        // Make a menu of adding filter object
        let addFilterObjectMenu = NSMenu(title: "")
        
            let sceneChange = NSMenuItem(title: "Scene Change", action: #selector(self.addFilterSceneChange(sender:)), keyEquivalent: "")
            addFilterObjectMenu.addItem(sceneChange)
        
            let colorToneCollection = NSMenuItem(title: "Color Tone Collection", action: #selector(self.addFilterColorToneCollection(sender:)), keyEquivalent: "")
            addFilterObjectMenu.addItem(colorToneCollection)
        
            let extendedColorToneCollection = NSMenuItem(title: "Extended Color Tone Collection", action: #selector(self.addFilterExtendedColorToneCollection(sender:)), keyEquivalent: "")
            addFilterObjectMenu.addItem(extendedColorToneCollection)
        
            let blur = NSMenuItem(title: "Blur", action: #selector(self.addFilterBlur(sender:)), keyEquivalent: "")
            addFilterObjectMenu.addItem(blur)
        
            let mosaic = NSMenuItem(title: "Mosaic", action: #selector(self.addFilterMosaic(sender:)), keyEquivalent: "")
            addFilterObjectMenu.addItem(mosaic)
        
            let luminescence = NSMenuItem(title: "Luminescence", action: #selector(self.addFilterLuminescense(sender:)), keyEquivalent: "")
            addFilterObjectMenu.addItem(luminescence)
        
            let diffusedLight = NSMenuItem(title: "Diffused Light", action: #selector(self.addFilterDiffusedLight(sender:)), keyEquivalent: "")
            addFilterObjectMenu.addItem(diffusedLight)
        
            let grow = NSMenuItem(title: "Grow", action: #selector(self.addFilterGrow(sender:)), keyEquivalent: "")
            addFilterObjectMenu.addItem(grow)
        
            let radiationBlur = NSMenuItem(title: "Radiation Blur", action: #selector(self.addFilterRadiationBlur(sender:)), keyEquivalent: "")
            addFilterObjectMenu.addItem(radiationBlur)
        
            let directionBlur = NSMenuItem(title: "Direction Blur", action: #selector(self.addFilterDirectionBlur(sender:)), keyEquivalent: "")
            addFilterObjectMenu.addItem(directionBlur)
        
            let lensBlur = NSMenuItem(title: "Lens Blur", action: #selector(self.addFilterLensBlur(sender:)), keyEquivalent: "")
            addFilterObjectMenu.addItem(lensBlur)
        
            let motionBlur = NSMenuItem(title: "Motion Blur", action: #selector(self.addFilterMotionBlur(sender:)), keyEquivalent: "")
            addFilterObjectMenu.addItem(motionBlur)
        
            let vibration = NSMenuItem(title: "Vibration", action: #selector(self.addFilterVibration(sender:)), keyEquivalent: "")
            addFilterObjectMenu.addItem(vibration)
        
            let flip = NSMenuItem(title: "Flip", action: #selector(self.addFilterFlip(sender:)), keyEquivalent: "")
            addFilterObjectMenu.addItem(flip)
        
            let raster = NSMenuItem(title: "Raster", action: #selector(self.addFilterRaster(sender:)), keyEquivalent: "")
            addFilterObjectMenu.addItem(raster)
        
            let imageLoop = NSMenuItem(title: "Image Loop", action: #selector(self.addFilterImageLoop(sender:)), keyEquivalent: "")
            addFilterObjectMenu.addItem(imageLoop)
        
            let colorShift = NSMenuItem(title: "Color Shift", action: #selector(self.addFilterColorShift(sender:)), keyEquivalent: "")
            addFilterObjectMenu.addItem(colorShift)
        
            let monochromatization = NSMenuItem(title: "Monochromatization", action: #selector(self.addFilterMonochromatization(sender:)), keyEquivalent: "")
            addFilterObjectMenu.addItem(monochromatization)
        
            let colorSetting = NSMenuItem(title: "Color Setting", action: #selector(self.addFilterColorSetting(sender:)), keyEquivalent: "")
            addFilterObjectMenu.addItem(colorSetting)
        
            let partialFilter = NSMenuItem(title: "Partial Filter", action: #selector(self.addPartialFilter(sender:)), keyEquivalent: "")
            addFilterObjectMenu.addItem(partialFilter)
        
            let audioDelay = NSMenuItem(title: "Audio Delay", action: #selector(self.addFilterAudioDelay(sender:)), keyEquivalent: "")
            addFilterObjectMenu.addItem(audioDelay)
        
            let noiseReduction = NSMenuItem(title: "Noise Reduction", action: #selector(self.addFilterNoiseReduction(sender:)), keyEquivalent: "")
            addFilterObjectMenu.addItem(noiseReduction)
        
            let simpleSharp = NSMenuItem(title: "Simple Sharp", action: #selector(self.addFilterSimpleSharp(sender:)), keyEquivalent: "")
            addFilterObjectMenu.addItem(simpleSharp)
        
            let simpleBlur = NSMenuItem(title: "Simple Blur", action: #selector(self.addFilterSimpleBlur(sender:)), keyEquivalent: "")
            addFilterObjectMenu.addItem(simpleBlur)
        
            let clipAndResize = NSMenuItem(title: "Clip & Resize", action: #selector(self.addFilterClipAndResize(sender:)), keyEquivalent: "")
            addFilterObjectMenu.addItem(clipAndResize)
        
            let edgeFill = NSMenuItem(title: "Edge Fill", action: #selector(self.addFilterEdgeFill(sender:)), keyEquivalent: "")
            addFilterObjectMenu.addItem(edgeFill)
        
            let volumeControll = NSMenuItem(title: "Volume Controll", action: #selector(self.addFilterVolumeControll(sender:)), keyEquivalent: "")
            addFilterObjectMenu.addItem(volumeControll)
        
        let addFilterObject = NSMenuItem(title: "Filter Object", action: nil, keyEquivalent: "")
        addFilterObject.submenu = addFilterObjectMenu
        menu.addItem(addFilterObject)
        
        // Make other menu items
        let addMidPoint = NSMenuItem(title: "Add Midpoint", action: #selector(self.addMidpoint(sender:)), keyEquivalent: "")
        menu.addItem(addMidPoint)
        
        return menu
    }
    
    func addMovie(sender: NSMenuItem) {
        //self.window?.windowController?.setDocumentEdited(true)
    }
    
    func addAudio(sender: NSMenuItem) {
        
    }
    
    func addPicture(sender: NSMenuItem) {
        
    }
    
    func addCameraControll(sender: NSMenuItem) {
        
    }
    
    func addOneFilter(sender: NSMenuItem) {
        
    }
    
    func addAudioWave(sender: NSMenuItem) {
        
    }
    
    func addShape(sender: NSMenuItem) {
        
    }
    
    func addText(sender: NSMenuItem) {
        
    }
    
    func addFilterSceneChange(sender: NSMenuItem) {
        
    }
    
    func addFilterColorToneCollection(sender: NSMenuItem) {
        
    }
    
    func addFilterExtendedColorToneCollection(sender: NSMenuItem) {
        
    }
    
    func addFilterBlur(sender: NSMenuItem) {
        
    }
    
    func addFilterMosaic(sender: NSMenuItem) {
        
    }
    
    func addFilterLuminescense(sender: NSMenuItem) {
        
    }
    
    func addFilterDiffusedLight(sender: NSMenuItem) {
        
    }
    
    func addFilterGrow(sender: NSMenuItem) {
        
    }
    
    func addFilterRadiationBlur(sender: NSMenuItem) {
        
    }
    
    func addFilterDirectionBlur(sender: NSMenuItem) {
        
    }
    
    func addFilterLensBlur(sender: NSMenuItem) {
        
    }
    
    func addFilterMotionBlur(sender: NSMenuItem) {
        
    }
    
    func addFilterVibration(sender: NSMenuItem) {
        
    }
    
    func addFilterFlip(sender: NSMenuItem) {
        
    }
    
    func addFilterRaster(sender: NSMenuItem) {
        
    }
    
    func addFilterImageLoop(sender: NSMenuItem) {
        
    }
    
    func addFilterColorShift(sender: NSMenuItem) {
        
    }
    
    func addFilterMonochromatization(sender: NSMenuItem) {
        
    }
    
    func addFilterColorSetting(sender: NSMenuItem) {
        
    }
    
    func addPartialFilter(sender: NSMenuItem) {
        
    }
    
    func addFilterAudioDelay(sender: NSMenuItem) {
        
    }
    
    func addFilterNoiseReduction(sender: NSMenuItem) {
        
    }
    
    func addFilterSimpleSharp(sender: NSMenuItem) {
        
    }
    
    func addFilterSimpleBlur(sender: NSMenuItem) {
        
    }
    
    func addFilterClipAndResize(sender: NSMenuItem) {
        
    }
    
    func addFilterEdgeFill(sender: NSMenuItem) {
        
    }
    
    func addFilterVolumeControll(sender: NSMenuItem) {
        
    }
    
    func addMidpoint(sender: NSMenuItem) {
        
    }
    
    override func mouseDown(with event: NSEvent) {
        timeBarX = event.locationInWindow.x - 94;
        self.setNeedsDisplay(self.frame)
    }
    
    override func mouseDragged(with event: NSEvent) {
        timeBarX = event.locationInWindow.x - 94;
        self.setNeedsDisplay(self.frame)
    }
}
