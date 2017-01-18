import Cocoa

class NewProjectViewController : NSViewController {
    @IBOutlet var widthText: NSTextField!
    @IBOutlet var heightText: NSTextField!
    @IBOutlet var isAutoResize: NSButton!
    
    @IBAction func createProject(_ sender: NSButton) {
        let editWindow = storyboard!.instantiateController(withIdentifier: "Main Window") as! NSWindowController
        let timeLineWindwow = storyboard!.instantiateController(withIdentifier: "Time Line Window") as! NSWindowController
        (editWindow.contentViewController as! MainViewController).editView.frame.size = CGSize(width: self.widthText.integerValue, height: self.heightText.integerValue)
        editWindow.showWindow(self)
        timeLineWindwow.showWindow(self)
    }
}
