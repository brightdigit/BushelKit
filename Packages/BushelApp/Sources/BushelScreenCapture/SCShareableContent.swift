//
// SCShareableContent.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(ScreenCaptureKit)
  import BushelLogging

  public import ScreenCaptureKit

  public enum CaptureError: Error {
    case shareableContentError(any Error)
    case missingWindowNumber(Int)
    case captureOutputError(any Error)
    case streamError(any Error)
  }

  @available(macOS 14.4, *)
  extension SCShareableContent {
    @MainActor
    public static func beginCapture(
      _ windowNumber: Int, _ handleError: @Sendable @escaping (CaptureError) -> Void
    ) -> any CaptureSession {
      let session = ShareableCaptureSession()
      Task {
        do {
          try await self.capture(windowNumber, with: session)
        } catch let error as CaptureError {
          handleError(error)
        }
      }
      return session
    }

    nonisolated static func capture(
      _ windowNumber: Int,
      with session: ShareableCaptureSession
    ) async throws(CaptureError) {
      let windows: [SCWindow]
      do {
        windows = try await SCShareableContent.currentProcess.windows
      } catch {
        throw .shareableContentError(error)
      }
      let window: SCWindow?
      window = windows.first {
        $0.windowID == CGWindowID(windowNumber)
      }
      guard let window else {
        throw .missingWindowNumber(windowNumber)
      }
      let output: CaptureOutput
      do {
        output = try CaptureOutput(session: session)
      } catch {
        throw .captureOutputError(error)
      }
      let filter = SCContentFilter(desktopIndependentWindow: window)
      let configuration = SCStreamConfiguration()
      configuration.capturesAudio = false
      configuration.excludesCurrentProcessAudio = true
      configuration.scalesToFit = true
      configuration.showsCursor = false
      configuration.preservesAspectRatio = true
      configuration.pixelFormat = kCVPixelFormatType_32BGRA
      let stream = SCStream(filter: filter, configuration: configuration, delegate: output)

      session.onStop {
        stream.stopCapture()
        output.stop()
      }
      do {
        try stream.addStreamOutput(output, type: .screen, sampleHandlerQueue: nil)
        try await stream.startCapture()
      } catch {
        throw .streamError(error)
      }
    }
  }
#endif
