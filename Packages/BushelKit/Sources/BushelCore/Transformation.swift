//
// Transformation.swift
// Copyright (c) 2023 BrightDigit.
//

import Foundation

public struct Transformation<T, U> {
  public init(_ closure: @escaping (T) -> U) {
    self.closure = closure
  }

  private let closure: (T) -> U
  public func callAsFunction(_ input: T) -> U {
    self.closure(input)
  }
}
