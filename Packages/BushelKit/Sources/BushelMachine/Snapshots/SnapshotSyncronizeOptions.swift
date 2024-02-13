//
// SnapshotSyncronizeOptions.swift
// Copyright (c) 2024 BrightDigit.
//

import BushelCore
import Foundation

public struct SnapshotSyncronizeOptions: OptionSet {
  public typealias RawValue = Int

  public let rawValue: Int

  public init(rawValue: Int) {
    self.rawValue = rawValue
  }
}
