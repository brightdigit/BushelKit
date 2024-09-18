//
// CaptureBuffer.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(CoreMedia)
  import CoreMedia

  internal struct CaptureBuffer {
    let pixelBuffer: CVPixelBuffer
    let presentationTime: CMTime

    private init(pixelBuffer: CVPixelBuffer, presentationTime: CMTime) {
      self.pixelBuffer = pixelBuffer
      self.presentationTime = presentationTime
    }
  }

  extension CaptureBuffer {
    init(sampleBuffer: CMSampleBuffer, topCroppedBy toolbarHeight: Int) throws(CaptureSessionError) {
      let presentationTime = CMSampleBufferGetPresentationTimeStamp(sampleBuffer)

      guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
        throw .missingPixelBuffer
      }

      let newPixelBuffer: CVPixelBuffer
      let newHeight = CVPixelBufferGetHeight(pixelBuffer) - toolbarHeight
      let newWidth = newHeight * 16 / 9
      let rect = CGRect(x: 0, y: toolbarHeight, width: newWidth, height: newHeight)
      do {
        newPixelBuffer = try pixelBuffer.crop(to: rect)
      } catch {
        throw .pixelBufferError(error)
      }

      self.init(pixelBuffer: newPixelBuffer, presentationTime: presentationTime)
    }
  }
#endif
