//
// Date+RawRepresentable.swift
// Copyright (c) 2024 BrightDigit.
//

import Foundation

extension Date: RawRepresentable {
  public typealias RawValue = Int
  static let millisecondsInSeconds: TimeInterval = 1000

  public var rawValue: Int {
    Int(self.timeIntervalSince1970 * Self.millisecondsInSeconds)
  }

  public init?(rawValue: Int) {
    self.init(timeIntervalSince1970: TimeInterval(rawValue) / Self.millisecondsInSeconds)
  }
}
