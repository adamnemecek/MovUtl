import Cocoa

class NewProjectViewController : NSViewController {
    @IBOutlet var widthText: NSTextField!
    @IBOutlet var heightText: NSTextField!
    @IBOutlet var audioSampleRateText: NSTextField!
    @IBOutlet var isAutoResize: NSButton!
    
    @IBAction func autoResize(_ sender: NSButton) {
        widthText.isEnabled = !widthText.isEnabled
        heightText.isEnabled = !heightText.isEnabled
    }
    @IBAction func createProject(_ sender: NSButton) {
        let document = (self.view.window?.windowController?.document as! MovUtlDocument)
        document.width = widthText.integerValue
        document.height = heightText.integerValue
        document.isInputed = true
        self.view.window?.close()
    }
}
