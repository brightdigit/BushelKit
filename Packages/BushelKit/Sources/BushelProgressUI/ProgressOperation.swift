//
// ProgressOperation.swift
// Copyright (c) 2024 BrightDigit.
//

import Foundation

public protocol ProgressOperation<ValueType>: Identifiable, Sendable where ID == URL {
  associatedtype ValueType: BinaryInteger & Sendable
  var currentValue: ValueType { get }
  var totalValue: ValueType? { get }
  func execute() async throws
}

public extension ProgressOperation {
  func percentValue(withFractionDigits fractionDigits: Int = 0) -> String? {
    guard let totalValue else {
      #warning("logging-note: should we log something here?")
      return nil
    }
    let formatter = NumberFormatter()
    formatter.maximumFractionDigits = fractionDigits
    formatter.minimumFractionDigits = fractionDigits
    let ratioValue = Double(currentValue) / Double(totalValue) * 100.0
    let string = formatter.string(from: .init(value: ratioValue))

    #warning("logging-note: let's log the calculated percent value if not done somewhere")
    assert(string != nil)
    return string
  }
}
