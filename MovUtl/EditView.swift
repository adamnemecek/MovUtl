import Cocoa
import OpenGL
import GLKit
import GLUT

class EditView : NSOpenGLView {
    var buffer : [CGImage] = []
    
    func allocateBuffer(size: UInt) {
        
    }
    
    override func draw(_ dirtyRect: NSRect) {
        let currentFrame = (self.window!.contentViewController as! ViewController).document!.data.currentFrame
        
        glClearColor(0, 0, 0, 0)
        glClear(GLbitfield(GL_COLOR_BUFFER_BIT))
        
        for object in (self.window!.contentViewController as! ViewController).objectsOn(current: currentFrame) {
            object.render(at: currentFrame)
        }
        
        glFlush()
    }
}
