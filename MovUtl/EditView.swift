import Cocoa

class EditView: NSView {
    override func draw(_ dirtyRect: NSRect) {
        NSColor.black.set()
        NSBezierPath.fill(dirtyRect)
        super.draw(dirtyRect)
    }
}
