import Cocoa
import OpenGL
import GLKit
import GLUT

class EditView : NSOpenGLView {
    var buffer : [CGImage] = []
    
    func allocateBuffer(size: UInt) {
        
    }
    
    override func draw(_ dirtyRect: NSRect) {
        glClearColor(0, 0, 0, 0)
        glClear(GLbitfield(GL_COLOR_BUFFER_BIT))
        
        
        
        glFlush()
    }
}
