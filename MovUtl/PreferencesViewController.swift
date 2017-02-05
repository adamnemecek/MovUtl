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
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        addObserver(self, forKeyPath: "maxBufWidth", options: [.new, .old], context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
    }
}
