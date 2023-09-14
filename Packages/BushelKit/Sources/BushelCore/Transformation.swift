//
// Transformation.swift
// Copyright (c) 2023 BrightDigit.
//

import Foundation

public struct Transformation<T, U> {
  private let closure: (T) -> U
  public init(_ closure: @escaping (T) -> U) {
    self.closure = closure
  }

  public func callAsFunction(_ input: T) -> U {
    self.closure(input)
  }
}
