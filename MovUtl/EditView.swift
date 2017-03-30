import Cocoa
import AVFoundation

class EditView: NSView {
    override func draw(_ dirtyRect: NSRect) {
        if let context = NSGraphicsContext.current()?.cgContext {
            context.setFillColor(CGColor.black)
            context.fill(dirtyRect)
            let document = (self.window?.windowController?.document as! MovUtlDocument)
            for layer in document.layerViews {
                for object in layer.objects! {
                    if object.startFrame <= document.currentFrame && document.currentFrame <= object.endFrame {
                        switch object.objectType {
                        //case .audiowave:
                            // TODO
                        case .movie:
                            let movieFramePos = object.endFrame - document.currentFrame
                            let asset = AVURLAsset(url: URL(fileURLWithPath: object.referencingFile))
                            let generator = AVAssetImageGenerator(asset: asset)
                            generator.maximumSize = self.frame.size
                            
                            var image: CGImage? = nil
                            do {
                                image = try generator.copyCGImage(at: CMTimeMake(Int64(movieFramePos), Int32(document.fps)), actualTime: nil)
                            } catch { }
                            
                            context.draw(image!, in: dirtyRect)
                        case .picture:
                            let image = CGImageSourceCreateWithURL(URL(fileURLWithPath: object.referencingFile) as CFURL, nil)
                            context.draw(CGImageSourceCreateImageAtIndex(image!, 0, nil)!, in: dirtyRect)
                        case .text:
                            let str = object.referencingFile as CFString
                            let attrStr = CFAttributedStringCreateMutable(kCFAllocatorDefault, 0)
                            CFAttributedStringReplaceString(attrStr, CFRangeMake(0, 0), str)
                            CFAttributedStringSetAttribute(attrStr, CFRangeMake(0, 0), kCTForegroundColorAttributeName, object.firstColor.cgColor)
                            
                            let path: CGPath = CGPath(rect: dirtyRect, transform: nil)
                            
                            let framesetter: CTFramesetter = CTFramesetterCreateWithAttributedString(attrStr!)
                            let frame: CTFrame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, nil)
                            
                            CTFrameDraw(frame, context)
                        default: break
                        }
                    }
                }
            }
        }
        super.draw(dirtyRect)
    }
}
