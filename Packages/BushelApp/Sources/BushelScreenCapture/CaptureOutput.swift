//
// CaptureOutput.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(AVFoundation) && canImport(ScreenCaptureKit)
  import AVFoundation
  import BushelLogging
  import ScreenCaptureKit

  internal class CaptureOutput: NSObject, SCStreamOutput, SCStreamDelegate, Loggable {
    static var loggingCategory: BushelLogging.Category {
      .audioVisual
    }

    let assetWriter: AVAssetWriter
    let videoInput: AVAssetWriterInput
    let adaptor: AVAssetWriterInputPixelBufferAdaptor
    let session: OutputSession
    let destinationURL: URL

    init(session: OutputSession, requestHeight: Int = 1_080) throws {
      let path: URL
      let width = requestHeight * 16 / 9
      let height = width * 9 / 16
      path = FileManager.default.temporaryDirectory
        .appending(path: session.id.uuidString)
        .appendingPathExtension(for: .quickTimeMovie)

      let assetWriter: AVAssetWriter = try .init(outputURL: path, fileType: .mov)
      let videoSettings: [String: Any] = [
        AVVideoCodecKey: AVVideoCodecType.h264,
        AVVideoWidthKey: width, // Adjust as needed
        AVVideoHeightKey: height
      ]
      let videoInput: AVAssetWriterInput = .init(mediaType: .video, outputSettings: videoSettings)
      videoInput.expectsMediaDataInRealTime = true
      let sourcePixelBufferAttributes: [String: Any] = [
        kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA,
        AVVideoWidthKey: width, // Adjust as needed
        AVVideoHeightKey: height // Adjust as needed
      ]
      let adaptor = AVAssetWriterInputPixelBufferAdaptor(
        assetWriterInput: videoInput,
        sourcePixelBufferAttributes: sourcePixelBufferAttributes
      )
      self.assetWriter = assetWriter
      self.videoInput = videoInput
      self.adaptor = adaptor
      self.session = session
      self.destinationURL = path

      if assetWriter.canAdd(videoInput) {
        assetWriter.add(videoInput)
      }
      super.init()
    }

    func append(sampleBuffer: CMSampleBuffer) throws(CaptureSessionError) -> Bool {
      let status: SessionStatus

      status = try SessionStatus(sampleBuffer: sampleBuffer, writingTo: self.assetWriter)

      let metrics: CaptureMetrics
      switch status {
      case let .active(activeMetrics):
        metrics = activeMetrics
      case .complete:
        // session.capture(self, didCompleteVideo: .init())
        return false
      }
      let toolbarHeight = Int(metrics.contentScale * 104.25)

      guard videoInput.isReadyForMoreMediaData else {
        throw CaptureSessionError.videoInputNotReady
      }

      let captureBuffer = try CaptureBuffer(sampleBuffer: sampleBuffer, topCroppedBy: toolbarHeight)
      try adaptor.append(captureBuffer: captureBuffer, writer: assetWriter)
      return true
    }

    func stream(_: SCStream, didOutputSampleBuffer sampleBuffer: CMSampleBuffer, of _: SCStreamOutputType) {
      let event = CaptureEvent { () throws(CaptureSessionError) -> Bool in
        try self.append(sampleBuffer: sampleBuffer)
      }
      self.session.capture(event: event)
    }

    func stop() {
      Self.logger.info("Stopping capture session")
      videoInput.markAsFinished()
      let session = self.session
      let url = self.destinationURL
      assetWriter.finishWriting {
        session.captureDidCompleteVideo(CaptureVideo(url: url))
      }
    }
  }
#endif
