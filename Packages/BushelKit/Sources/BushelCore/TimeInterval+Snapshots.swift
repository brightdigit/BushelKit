//
// TimeInterval+Snapshots.swift
// Copyright (c) 2024 BrightDigit.
//

import Foundation

public extension TimeInterval {
  enum Snapshot {
    public static let intervalIncrements: TimeInterval = 15.0
    public static let defaultInterval: TimeInterval = 5.0
  }
}
