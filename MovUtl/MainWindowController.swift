import Cocoa

class MainWindowController: NSWindowController {
    func updateDocument() {
        let doc = self.document as! Document
        (window?.contentViewController as! ViewController).updateDocument(with: doc)
    }
}
