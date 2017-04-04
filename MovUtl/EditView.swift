import Cocoa
import AVFoundation

extension CGPoint {
    static func +(left: CGPoint, right: CGPoint) -> CGPoint {
        return CGPoint(x: left.x + right.x, y: left.y + right.y)
    }
}

extension CGSize {
    static func +(left: CGSize, right: CGSize) -> CGSize {
        return CGSize(width: left.width + right.width, height: left.height + right.height)
    }
}

extension CGRect {
    static func +(left: CGRect, right: CGRect) -> CGRect {
        return CGRect(origin: left.origin + right.origin, size: left.size + right.size)
    }
    
    static func *(left: CGRect, right: CGFloat) -> CGRect {
        return CGRect(x: left.origin.x * right, y: left.origin.y * right, width: left.size.width * right, height: left.size.height * right)
    }
}

class EditView: NSView {
    override func draw(_ dirtyRect: NSRect) {
        if let context = NSGraphicsContext.current()?.cgContext {
            context.clear(dirtyRect)
            context.setFillColor(CGColor.black)
            context.fill(dirtyRect)
            let document = (self.window?.windowController?.document as! MovUtlDocument)
            for context in [context, document.context!] {
                context.beginPath()
                for layer in document.layerViews {
                    for object in layer.objects! {
                        if object.startFrame <= document.currentFrame && document.currentFrame <= object.endFrame {
                            switch object.objectType {
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
                                CFAttributedStringSetAttribute(attrStr, CFRangeMake(0, 0), kCTForegroundColorAttributeName, object.firstColor)
                                
                                let path: CGPath = CGPath(rect: dirtyRect, transform: nil)
                                
                                let framesetter: CTFramesetter = CTFramesetterCreateWithAttributedString(attrStr!)
                                let frame: CTFrame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, nil)
                                
                                CTFrameDraw(frame, context)
                            case .shape:
                                switch object.name {
                                case "Circle":
                                    context.addEllipse(in: CGRect(x: object.properties[0], y: object.properties[1], width: object.properties[2], height: object.properties[3]))
                                case "Rect":
                                    context.addRect(CGRect(x: object.properties[0], y: object.properties[1], width: object.properties[2], height: object.properties[3]))
                                case "Triangle":
                                    context.addLine(to: CGPoint(x: object.properties[0], y: object.properties[1]))
                                    context.addLine(to: CGPoint(x: object.properties[2], y: object.properties[1]))
                                    context.addLine(to: CGPoint(x: object.properties[3] / 2, y: object.properties[4]))
                                default: break
                                }
                            case .audiowave:
                                //Now properties are: Using audio track(Bool), Type(Int)
                                if Bool(object.properties[0] as NSNumber) {
                                    
                                } else if let url = CFURLCreateWithFileSystemPath(CFAllocatorGetDefault() as! CFAllocator!, object.referencingFile as CFString, .cfurlposixPathStyle, true) {
                                    var asbDescription = AudioStreamBasicDescription(mSampleRate: document.audioSampleRate, mFormatID: kAudioFormatLinearPCM, mFormatFlags: kLinearPCMFormatFlagIsSignedInteger | kLinearPCMFormatFlagIsBigEndian | kLinearPCMFormatFlagIsPacked, mBytesPerPacket: 4, mFramesPerPacket: 1, mBytesPerFrame: 4, mChannelsPerFrame: 2, mBitsPerChannel: 16, mReserved: 0)
                                    var file: AudioFileID? = nil
                                    AudioFileCreateWithURL(url, kAudioFileWAVEType, &asbDescription, AudioFileFlags.dontPageAlignAudioData, &file)
                                    
                                    var fileByteCount: Int64 = 0
                                    var size = UInt32(MemoryLayout<AudioStreamBasicDescription>.size)
                                    AudioFileGetProperty(file!, kAudioFilePropertyAudioDataByteCount, &size, &fileByteCount)
                                    
                                    var buffer = [Int8](repeating:0, count:Int(fileByteCount))
                                    var totalFrame = UInt32(document.totalFrame)
                                    AudioFileReadBytes(file!, true, 0, &totalFrame, &buffer)
                                    
                                    context.setStrokeColor(object.firstColor)
                                    for i in 0..<buffer.count {
                                        let stack = buffer[i]
                                        switch Int(object.properties[1]) {
                                        case 0:
                                            //Type1: Round wave
                                            context.setLineCap(.round)
                                            context.setLineJoin(.round)
                                            context.addLine(to: CGPoint(x: i, y: Int(stack)))
                                        case 1:
                                            //Type2: Dash wave
                                            context.setLineCap(.square)
                                            context.setLineJoin(.bevel)
                                            context.setLineDash(phase: 0, lengths: [CGFloat(object.properties[2]), CGFloat(object.properties[3])])
                                            context.addLine(to: CGPoint(x: i, y: Int(stack)))
                                        case 2:
                                            //Type3: Rects wave
                                            let threshold = object.properties[2]
                                            for j in 0..<(Int(stack) % threshold) {
                                                context.addRect(CGRect(x: i * object.properties[3], y: j * object.properties[4], width: object.properties[5], height: object.properties[6]) + dirtyRect)
                                            }
                                        case 3:
                                            //Type4: Filled round wave
                                            context.setFillColor(object.secondColor)
                                            context.setLineCap(.round)
                                            context.setLineJoin(.round)
                                            context.addLine(to: CGPoint(x: i, y: Int(stack)))
                                        case 4:
                                            //Type5: Bar wave
                                            context.addLine(to: CGPoint(x: i, y: Int(stack/2)) + dirtyRect.origin)
                                            context.addLine(to: CGPoint(x: i, y: Int(stack/2)) + dirtyRect.origin)
                                        default: break
                                        }
                                    }
                                    AudioFileClose(file!)
                                }
                            //case .oneFilter:
                                
                            case .filter:
                                //Now properties are: Par1(Double), Par2(Double), Flip(Boolean), Type(Int)
                                switch object.filterType {
                                case .sceneChange:
                                    let duration = object.endFrame - object.startFrame
                                    let process = CGFloat(document.currentFrame - object.startFrame)/CGFloat(duration)
                                    
                                    let start = renderFrame(object.startFrame)
                                    let end = renderFrame(object.endFrame)
                                    switch object.properties[3] {
                                    case 0://SceneChangeType.crossFadelet
                                        context.setAlpha(process)
                                        context.draw(start!, in: dirtyRect)
                                        context.setAlpha(1 - process)
                                        context.draw(end!, in: dirtyRect)
                                    case 1://SceneChangeType.circleWipe
                                        context.addArc(center: dirtyRect.origin, radius: 4096, startAngle: CGFloat(object.properties[4]), endAngle: process * 360.0, clockwise: false)
                                        context.clip()
                                    case 2://SceneChangeType.rectWipe
                                        context.clip(to: CGRect(x: object.properties[4], y: object.properties[5], width: object.properties[6], height: object.properties[7]), mask: start!)
                                    case 3://SceneChangeType.clockWipe
                                        context.addArc(center: dirtyRect.origin, radius: 4096, startAngle: 0, endAngle: process * 360.0, clockwise: true)
                                        context.clip()
                                    case 4://SceneChangeType.slice
                                        let height = CGFloat(Int(dirtyRect.size.height)/object.properties[4])
                                        for i in 0..<object.properties[4] {
                                            if i % 2 == 0 {
                                                context.draw(start!, in: CGRect(x: process*dirtyRect.size.width, y: CGFloat(i)*height, width: dirtyRect.width, height: height))
                                            } else {
                                                context.draw(start!, in: CGRect(x: dirtyRect.width - process*dirtyRect.size.width, y: CGFloat(i)*height, width: dirtyRect.width, height: height))
                                            }
                                        }
                                    case 5://SceneChangeType.swap
                                        if process < 0.5 {
                                            context.draw(start!, in: CGRect(x: dirtyRect.origin.x * 0.8, y: dirtyRect.origin.y * 0.8, width: dirtyRect.size.width * 1.2, height: dirtyRect.size.height * 1.2) * process)
                                        } else {
                                            context.draw(start!, in: CGRect(x: dirtyRect.origin.x * 0.8 * (1 - process), y: dirtyRect.origin.y * 0.8, width: dirtyRect.size.width * 1.2, height: dirtyRect.size.height * 1.2))
                                            context.draw(end!, in: CGRect(x: dirtyRect.origin.x * (1 - process), y: dirtyRect.origin.y, width: dirtyRect.size.width, height: dirtyRect.size.height))
                                        }
                                    case 6://SceneChangeType.slide
                                        let halfCross = sqrt(pow(dirtyRect.width, 2)+pow(dirtyRect.height, 2)) / 2
                                        let deg = object.properties[4]
                                        let moveX = sin(CGFloat(deg)) * halfCross * process
                                        let moveY = cos(CGFloat(deg)) * halfCross * process
                                        context.draw(end!, in: dirtyRect)
                                        context.draw(start!, in: CGRect(x: dirtyRect.origin.x + moveX, y: dirtyRect.origin.y + moveY, width: dirtyRect.width, height: dirtyRect.height))
                                    case 7://SceneChangeType.minimizeRotate
                                        context.draw(end!, in: dirtyRect)
                                        context.rotate(by: process * 360)
                                        context.scaleBy(x: 1 - process, y: 1 - process)
                                        context.setAlpha(process)
                                        context.draw(start!, in: dirtyRect)
                                    case 8://SceneChangeType.pushHorizonal
                                        context.draw(end!, in: CGRect(x: dirtyRect.origin.x, y: dirtyRect.origin.y * process, width: dirtyRect.size.width, height: dirtyRect.size.height))
                                        context.draw(start!, in: CGRect(x: dirtyRect.origin.x, y: dirtyRect.origin.y * (1 - process), width: dirtyRect.size.width, height: dirtyRect.size.height))
                                    case 9://SceneChangeType.pushVertical
                                        context.draw(end!, in: CGRect(x: dirtyRect.origin.x * process, y: dirtyRect.origin.y, width: dirtyRect.size.width, height: dirtyRect.size.height))
                                        context.draw(start!, in: CGRect(x: dirtyRect.origin.x * (1 - process), y: dirtyRect.origin.y, width: dirtyRect.size.width, height: dirtyRect.size.height))
                                    /* TODO
                                    case 10://SceneChangeType.rotateHorizonal
                                    case 11://SceneChangeType.rotateVertical
                                    case 12://SceneChangeType.cubicHorizonal
                                    case 13://SceneChangeType.cubicRotateVertical
                                    case 14://SceneChangeType.fadeInOut
                                    case 15://SceneChangeType.radiationBlur
                                    case 16://SceneChangeType.blur
                                    case 17://SceneChangeType.wipeHorizonal
                                    case 18://SceneChangeType.wipeVertical
                                    case 19://SceneChangeType.rollHorizonal
                                    case 20://SceneChangeType.rollVertical
                                    case 21://SceneChangeType.randomLine
                                    case 22://SceneChangeType.grow
                                    case 23://SceneChangeType.lensBlur
                                    case 24://SceneChangeType.door
                                    case 25://SceneChangeType.wakeUp
                                    case 26://SceneChangeType.reelRotate
                                    case 27://SceneChangeType.shapeWipe
                                    case 28://SceneChangeType.hidingShapeWipe
                                    case 29://SceneChangeType.radiationHidingShapeWipe
                                    case 30://SceneChangeType.clush
                                    case 31://SceneChangeType.rollPage
                                    */
                                    default: break
                                    }
                                    
                                default: break
                                }
                            default: break
                            }
                            //Effect rendering
                            //for effect in object.effectFilters {
                                
                            //}
                            
                        }
                        context.setAlpha(object.alpha)
                    }
                    context.closePath()
                }
            }
        }
        super.draw(dirtyRect)
    }
    
    func renderFrame(_ frame: UInt64) -> CGImage? {
        //TODO
        return nil
    }
}
