//
// AVAssetWriterInputPixelBufferAdaptor.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(AVFoundation)
  import AVFoundation

  extension AVAssetWriterInputPixelBufferAdaptor {
    private func append(captureBuffer: CaptureBuffer) {
      self.append(captureBuffer.pixelBuffer, withPresentationTime: captureBuffer.presentationTime)
    }

    func append(captureBuffer: CaptureBuffer, writer: AVAssetWriter) throws(CaptureSessionError) {
      self.append(captureBuffer: captureBuffer)

      if writer.status == .failed {
        throw .assetWriterFailure(writer.error)
      }
    }
  }
#endif
