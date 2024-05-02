//
// Transformation.swift
// Copyright (c) 2024 BrightDigit.
//

import Foundation

public struct Transformation<T, U>: Sendable {
  private let closure: @Sendable (T) -> U
  public init(_ closure: @Sendable @escaping (T) -> U) {
    self.closure = closure
  }

  @Sendable
  public func callAsFunction(_ input: T) -> U {
    self.closure(input)
  }
}
