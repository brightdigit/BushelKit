//
// SessionStatus.swift
// Copyright (c) 2024 BrightDigit.
//

internal enum SessionStatus {
  case complete
  case active(CaptureMetrics)
}

#if canImport(CoreMedia) && canImport(ScreenCaptureKit) && canImport(AVFoundation)

  import AVFoundation

  extension SessionStatus {
    internal init(
      sampleBuffer: CMSampleBuffer,
      writingTo assetWriter: AVAssetWriter
    ) throws(CaptureSessionError) {
      let presentationTime = CMSampleBufferGetPresentationTimeStamp(sampleBuffer)

      guard let attachmentStatus = sampleBuffer.attachmentStatus else {
        throw .missingAttachments
      }

      let contentScale: CGFloat

      switch attachmentStatus {
      case let .active(metrics):
        contentScale = metrics.contentScale
      case .complete:
        self = .complete
        return
      }

      let isStarting: Bool
      let writingStatus = assetWriter.verifyWriting(atSourceTime: presentationTime)

      switch writingStatus {
      case let .invalid(status):
        throw .invalidAssetWriterStatus(status.rawValue)
      case .active:
        isStarting = false
      case .starting:
        isStarting = true
      }

      self = .active(.init(contentScale: contentScale, isStarting: isStarting))
    }
  }
#endif
