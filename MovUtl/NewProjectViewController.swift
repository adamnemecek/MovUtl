import Cocoa

class NewProjectViewController : NSViewController {
    @IBOutlet var widthText: NSTextField!
    @IBOutlet var heightText: NSTextField!
    @IBOutlet var isAutoResize: NSButton!
    
    @IBAction func autoResize(_ sender: NSButton) {
        widthText.isEnabled = !widthText.isEnabled
        heightText.isEnabled = !heightText.isEnabled
    }
    @IBAction func createProject(_ sender: NSButton) {
        
        self.view.window?.close()
    }
}
