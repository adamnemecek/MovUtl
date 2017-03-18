import Cocoa

class PreferncesViewController : NSViewController {
    @IBOutlet var maxBufWidth: NSTextField!
    @IBOutlet var maxBufHeight: NSTextField!
    @IBOutlet var maxFrames: NSTextField!
    @IBOutlet var cashFrames: NSTextField!
    @IBOutlet var cashCodecInfo: NSButton!
    @IBOutlet var saveEncodeSetting: NSButton!
    @IBOutlet var displayFrom1: NSButton!
    @IBOutlet var useYUY2: NSButton!
    @IBOutlet var moveAnyA: NSTextField!
    @IBOutlet var moveAnyB: NSTextField!
    @IBOutlet var moveAnyC: NSTextField!
    @IBOutlet var moveAnyD: NSTextField!
    
    let userDefaults = UserDefaults.standard
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        for key in ["maxBufWidth", "maxBufHeight", "maxFrames", "cashFrames", "cashCodecInfo", "saveEncodeSetting", "displayFrom1", "useYUY2", "moveAnyA", "moveAnyB", "moveAnyC", "moveAnyD"] {
            addObserver(self, forKeyPath: key, options: [.new], context: nil)
        }
    }
    
    deinit {
        for key in ["maxBufWidth", "maxBufHeight", "maxFrames", "cashFrames", "cashCodecInfo", "saveEncodeSetting", "displayFrom1", "useYUY2", "moveAnyA", "moveAnyB", "moveAnyC", "moveAnyD"] {
            removeObserver(self, forKeyPath: key)
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        let key = keyPath ?? ""
        switch key {
        case "maxBufWifth":
            userDefaults.set((change![.newKey] as? NSTextField)?.integerValue, forKey: key)
        case "maxBufHeight":
            userDefaults.set((change![.newKey] as? NSTextField)?.integerValue, forKey: key)
        case "maxFrames":
            userDefaults.set((change![.newKey] as? NSTextField)?.integerValue, forKey: key)
        case "cashFrames":
            userDefaults.set((change![.newKey] as? NSTextField)?.integerValue, forKey: key)
        case "cashCodecInfo":
            userDefaults.set((change![.newKey] as? NSButton)?.state, forKey: key)
        case "saveEncodeSetting":
            userDefaults.set((change![.newKey] as? NSButton)?.state, forKey: key)
        case "displayFrom1":
            userDefaults.set((change![.newKey] as? NSButton)?.state, forKey: key)
        case "useYYUY2":
            userDefaults.set((change![.newKey] as? NSButton)?.state, forKey: key)
        case "moveAnyA":
            userDefaults.set((change![.newKey] as? NSTextField)?.integerValue, forKey: key)
        case "moveAnyB":
            userDefaults.set((change![.newKey] as? NSTextField)?.integerValue, forKey: key)
        case "moveAnyC":
            userDefaults.set((change![.newKey] as? NSTextField)?.integerValue, forKey: key)
        case "moveAnyD":
            userDefaults.set((change![.newKey] as? NSTextField)?.integerValue, forKey: key)
        default: break
        }
        userDefaults.synchronize()
        print(key)
    }
    
    @IBAction func reset(_ sender: NSButton) {
        UserDefaults.resetStandardUserDefaults()
    }
}
