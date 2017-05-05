import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        var defaults: [String : Any] = [:]
        
        defaults["maxBufWidth"] = 4096
        defaults["maxBufHeight"] = 3072
        defaults["maxFrames"] = 20000
        defaults["cashFrames"] = 10
        defaults["cashCodecInfo"] = true
        defaults["saveEncodeSetting"] = true
        defaults["displayFrom1"] = true
        defaults["useYUY2"] = false
        defaults["moveAnyA"] = 5
        defaults["moveAnyB"] = 10
        defaults["moveAnyC"] = 50
        defaults["moveAnyD"] = 100
        
        UserDefaults.standard.register(defaults: defaults)
        if UserDefaults.standard.synchronize() {
            print("Notifcated!")
        }
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return false
    }
    
    func applicationOpenUntitledFile(_ sender: NSApplication) -> Bool {
        return false
    }
    
    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        return false
    }
    
    @IBAction func openPreferences(_ sender: NSMenuItem) {
        PreferencesWindowController.instance.showWindow(sender)
    }
}

