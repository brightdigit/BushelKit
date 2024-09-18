//
// ShareableCaptureSession.swift
// Copyright (c) 2024 BrightDigit.
//

import BushelLogging
import Foundation

#if canImport(os)
  import struct os.OSLogType

  private typealias LogLevel = os.OSLogType
#else
  import struct Logging.Logger

  private typealias LogLevel = Logging.Logger.Level
#endif

internal struct ShareableCaptureSession: CaptureSession, Sendable, OutputSession, Loggable {
  private final class CaptureHandler: Loggable, Sendable {
    static var loggingCategory: BushelLogging.Category {
      .audioVisual
    }

    private nonisolated(unsafe) var stopHandler: (() -> Void)?

    func setHandler(_ handler: @escaping () -> Void) {
      assert(self.stopHandler == nil)
      stopHandler = handler
    }

    func stop() {
      assert(stopHandler != nil)
      guard let stopHandler else {
        Self.logger.error("stopHandler is nil")
        return
      }
      stopHandler()
    }
  }

  static var loggingCategory: BushelLogging.Category {
    .audioVisual
  }

  internal let id: UUID
  private let handler = CaptureHandler()

  internal init(id: UUID = UUID()) {
    self.id = id
  }

  func stop() {
    self.handler.stop()
  }

  func onStop(perform action: @escaping () -> Void) {
    self.handler.setHandler(action)
  }

  func captureDidCompleteVideo(_ video: CaptureVideo) {
    Self.logger.info("Video Captured at: \(video.url)")
  }

  func capture(event: CaptureEvent) {
    let level: LogLevel = if case .error = event {
      LogLevel.error
    } else {
      .debug
    }

    Self.logger.log(level: level, "Capture \(event)")
  }
}
