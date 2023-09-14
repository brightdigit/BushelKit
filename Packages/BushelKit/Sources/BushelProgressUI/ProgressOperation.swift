//
// ProgressOperation.swift
// Copyright (c) 2023 BrightDigit.
//

import Foundation

public protocol ProgressOperation<ValueType>: Identifiable where ID == URL {
  associatedtype ValueType: BinaryInteger
  var currentValue: ValueType { get }
  var totalValue: ValueType? { get }
  func execute() async throws
}

public extension ProgressOperation {
  func percentValue(withFractionDigits fractionDigits: Int = 0) -> String? {
    guard let totalValue else {
      return nil
    }
    let formatter = NumberFormatter()
    formatter.maximumFractionDigits = fractionDigits
    formatter.minimumFractionDigits = fractionDigits
    let ratioValue = Double(currentValue) / Double(totalValue) * 100.0
    let string = formatter.string(from: .init(value: ratioValue))
    assert(string != nil)
    return string
  }
}
