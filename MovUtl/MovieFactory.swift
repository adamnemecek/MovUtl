import Cocoa
import AVFoundation
import Quartz

class MovieFactory: NSObject {
    func writeMovie(_ data:ProjectData, videoPath path:String) {
        // Make asset writer
        let url = URL(fileURLWithPath: path)
        var assetWriter: AVAssetWriter?
        do {
            assetWriter = try AVAssetWriter(url: url, fileType: AVFileTypeQuickTimeMovie)
            
            let videoSettings: [String : AnyObject] = [
                AVVideoCodecKey  : AVVideoCodecH264 as AnyObject,
                AVVideoWidthKey  : data.width as AnyObject,
                AVVideoHeightKey : data.height as AnyObject,
                ]
            
            let assetWriterVideoInput = AVAssetWriterInput(mediaType: AVMediaTypeVideo, outputSettings: videoSettings)
            assetWriter?.add(assetWriterVideoInput)
            
            // Return writer
            print("Created asset writer for \(data.width)x\(data.height) video")
        } catch {
            print("Error creating asset writer: \(error)")
        }
        
        if let assetWriter = assetWriter {
            // Make pixel buffer adaptor
            let writerInput = assetWriter.inputs.filter{ $0.mediaType == AVMediaTypeVideo }.first!
            let sourceBufferAttributes : [String : AnyObject] = [
                kCVPixelBufferPixelFormatTypeKey as String : Int(kCVPixelFormatType_32ARGB) as AnyObject,
                kCVPixelBufferWidthKey as String : data.width as AnyObject,
                kCVPixelBufferHeightKey as String : data.height as AnyObject,
                ]
            let pixelBufferAdaptor = AVAssetWriterInputPixelBufferAdaptor(assetWriterInput: writerInput, sourcePixelBufferAttributes: sourceBufferAttributes)
            
            assetWriter.startWriting()
            assetWriter.startSession(atSourceTime: kCMTimeZero)
            if (pixelBufferAdaptor.pixelBufferPool == nil) {
                print("Error converting images to video: pixelBufferPool nil after starting session")
                return
            }
            
            let mediaQueue = DispatchQueue(label: "mediaInputQueue", attributes: [])
            
            let frameDuration = CMTimeMake(1, Int32(data.fps))
            var frameCount: UInt64 = 0
            
            writerInput.requestMediaDataWhenReady(on: mediaQueue, using: { 
                while writerInput.isReadyForMoreMediaData && frameCount < data.totalFrame {
                    let lastFrameTime = CMTimeMake(Int64(frameCount), Int32(data.fps))
                    let presentationTime = (frameCount == 0 ? lastFrameTime : CMTimeAdd(lastFrameTime, frameDuration))
                    
                    // Write a frame
                    // TODO
                    
                    frameCount += 1
                }
                
                if (frameCount >= data.totalFrame) {
                    writerInput.markAsFinished()
                    assetWriter.finishWriting {
                        if (assetWriter.error != nil) {
                            print("Error converting images to video: \(String(describing: assetWriter.error))")
                        } else {
                            print("Converted images to movie @ \(path)")
                        }
                    }
                }
            })
            
        } else {
            return
        }
    }
}
