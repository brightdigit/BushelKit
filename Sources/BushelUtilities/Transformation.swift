//
//  Transformation.swift
//  BushelKit
//
//  Created by Leo Dion.
//  Copyright © 2025 BrightDigit.
//
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the “Software”), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or
//  sell copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
//

internal import Foundation

/// A struct that applies a transformation to a value of type `T` and returns a value of type `U`.
public struct Transformation<T, U>: Sendable {
  /// The closure that performs the transformation.
  private let closure: @Sendable (T) -> U

  /// Initializes the `Transformation` with a closure
  /// that transforms a value of type `T` to a value of type `U`.
  /// - Parameter closure: The closure that performs the transformation.
  public init(_ closure: @Sendable @escaping (T) -> U) {
    self.closure = closure
  }

  /// Applies the transformation to the provided input and returns the transformed value.
  /// - Parameter input: The value to be transformed.
  /// - Returns: The transformed value.
  @Sendable
  public func callAsFunction(_ input: T) -> U {
    self.closure(input)
  }
}
