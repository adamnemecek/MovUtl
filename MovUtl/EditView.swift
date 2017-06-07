import Cocoa
import OpenGL

class EditView : NSView {
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
        let context = NSGraphicsContext.current()?.cgContext
        NSColor.black.setFill()
        context?.fill(dirtyRect)
    }
}
