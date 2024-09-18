//
// OutputSession.swift
// Copyright (c) 2024 BrightDigit.
//

import Foundation

internal protocol OutputSession: Sendable {
  var id: UUID { get }
  func captureDidCompleteVideo(_ video: CaptureVideo)
  func capture(event: CaptureEvent)
}
