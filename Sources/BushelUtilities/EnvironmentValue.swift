//
//  EnvironmentValue.swift
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

/// A protocol that represents an environment value
/// that can be sent between different parts of an application.
public protocol EnvironmentValue: Sendable {
  /// The default value for the environment value.
  static var `default`: Self { get }

  /// The string representation of the environment value.
  var environmentStringValue: String { get }

  /// Initializes the environment value from a string representation.
  /// - Parameter environmentStringValue: The string representation of the environment value.
  init?(environmentStringValue: String)
}

extension EnvironmentValue where Self: LosslessStringConvertible {
  /// The string representation of the environment value.
  public var environmentStringValue: String {
    self.description
  }

  /// Initializes the environment value from a string representation.
  /// - Parameter environmentStringValue: The string representation of the environment value.
  public init?(environmentStringValue: String) {
    self.init(environmentStringValue)
  }
}

extension EnvironmentValue where Self: RawRepresentable, RawValue == String {
  /// The string representation of the environment value.
  public var environmentStringValue: String {
    self.rawValue
  }

  /// Initializes the environment value from a string representation.
  /// - Parameter environmentStringValue: The string representation of the environment value.
  public init?(environmentStringValue: String) {
    self.init(rawValue: environmentStringValue)
  }
}

extension Bool: EnvironmentValue {
  /// The default value for the environment value.
  public static var `default`: Bool {
    false
  }
}

extension Int: EnvironmentValue {
  public static var `default`: Int {
    0
  }
}
