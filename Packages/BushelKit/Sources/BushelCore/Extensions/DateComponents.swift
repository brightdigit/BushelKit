//
// DateComponents.swift
// Copyright (c) 2024 BrightDigit.
//

import Foundation

public extension DateComponents {
  init(fromSeconds secondsInterval: TimeInterval) {
    let seconds = Int(secondsInterval)
    let nanoSeconds = Int(secondsInterval.remainder(dividingBy: 1.0) * 1_000_000)
    self.init(second: seconds, nanosecond: nanoSeconds)
  }
}
