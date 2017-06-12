import Cocoa
import OpenGL
import GLKit
import GLUT

class EditView : NSOpenGLView {
    override func draw(_ dirtyRect: NSRect) {
        glClearColor(0, 0, 0, 0)
        glClear(GLbitfield(GL_COLOR_BUFFER_BIT))
        
        if let data = (window?.windowController?.document as? Document)?.data {
            for layer in data.layers {
                for object in layer.objects ?? [] {
                    
                    if data.currentFrame <= object.startFrame && object.endFrame <= data.currentFrame {
                        
                        if object.objectType == .shape {
                            
                            if object.properties[0] == 0 { // Background
                                let color = object.secondColor
                                glColor4d(Double((color.components?[0])!), Double((color.components?[1])!), Double((color.components?[2])!), Double((color.components?[3])!))
                                
                                glBegin(GLenum(GL_QUADS))
                                
                                glVertex3i(1, 1, 0)
                                glVertex3i(-1, 1, 0)
                                glVertex3i(-1, -1, 0)
                                glVertex3i(1, -1, 0)
                                
                                glEnd()
                            }
                            
                        }
                        
                    }
                    
                }
            }
        }
        
        glFlush()
    }
}
