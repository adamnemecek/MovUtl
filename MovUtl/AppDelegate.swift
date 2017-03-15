import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return false
    }
    
    var preferencesController : NSWindowController?
    
    @IBAction func openPreferences(_ sender: NSMenuItem) {
        if preferencesController == nil {
            preferencesController = NSWindowController(windowNibName: "PreferencesWindow")
        }
        preferencesController?.showWindow(sender)
    }
}

