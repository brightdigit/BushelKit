//
// PreviewOperation.swift
// Copyright (c) 2023 BrightDigit.
//

import Foundation

public struct PreviewOperation<ValueType: BinaryInteger>: ProgressOperation {
  public let currentValue: ValueType

  public let totalValue: ValueType?

  public let id: URL

  public init(currentValue: ValueType, totalValue: ValueType?, id: URL) {
    self.currentValue = currentValue
    self.totalValue = totalValue
    self.id = id
  }

  public func execute() async throws {}

  public func cancel() {}
}