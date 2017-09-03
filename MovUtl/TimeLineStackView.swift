import  Cocoa

class TimeLineStackView : NSStackView {
    override var isFlipped: Bool {
        get {
            return true
        }
    }
}
