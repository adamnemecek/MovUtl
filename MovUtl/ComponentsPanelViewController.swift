import Cocoa

class ComponentsPanelViewController: NSViewController {
    
    @IBOutlet var cameraButton: NSButton!
    @IBOutlet var clippingButton: NSButton!
    @IBOutlet var mouseMovingButton: NSButton!
    @IBOutlet var disableButton: NSButton!
    @IBOutlet var firstColorWell: NSColorWell!
    @IBOutlet var secondColorWell: NSColorWell!
    
    @IBAction func toggleCameraControll(_ sender: NSButton) {
    }
    
    @IBAction func toggleClippingObjectBelow(_ sender: NSButton) {
    }

    @IBAction func toggleMouseMoving(_ sender: NSButton) {
        
    }
    
    @IBAction func disable(_ sender: NSButton) { //or Enable
        
    }
    
    @IBAction func changeFirstColor(_ sender: NSColorWell) {
        
    }
    
    @IBAction func changeSecondColor(_ sender: NSColorWell) {
        
    }
}
