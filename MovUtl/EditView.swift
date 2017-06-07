import Cocoa
import OpenGL
import GLKit
import GLUT

class EditView : NSOpenGLView {
    override func draw(_ dirtyRect: NSRect) {
        glClearColor(0, 0, 0, 0)
        glClear(GLbitfield(GL_COLOR_BUFFER_BIT))
        
        glColor3i(0, 1, 0)
        glBegin(GLenum(GL_TRIANGLES))
        
        glVertex3f(  0.5,  0.5, 0.0)
        glVertex3f( -0.5,  0.5, 0.0)
        glVertex3f( -0.5, -0.5 ,0.0)
        
        glEnd()
        
        glFlush()
    }
}
