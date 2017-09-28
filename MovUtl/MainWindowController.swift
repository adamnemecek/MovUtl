import Cocoa

class MainWindowController: NSWindowController {
    override func windowTitle(forDocumentDisplayName displayName: String) -> String {
        return displayName + " - [\((self.document as! Document).data.currentFrame)/\((self.document as! Document).data.totalFrame)]"
    }
}
