//
//  EnvironmentProperty.swift
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

public import Foundation

/// A property wrapper that provides access to an environment value.
///
/// The `EnvironmentProperty` type is a property wrapper
///  that provides a convenient way to access environment values,
///  such as those stored in the process's environment variables or other sources.
///
/// - Parameters:
///   - key: The key associated with the environment value.
///   - source: The source of the environment values,
///   which defaults to `ProcessInfo.processInfo.environment`.
@propertyWrapper
public struct EnvironmentProperty<Value: EnvironmentValue>: Sendable {
  /// The wrapped value, which is the environment value associated with the specified key.
  public var wrappedValue: Value {
    self.accessor.value
  }

  private let accessor: ValueAccessor

  private init(accessor: EnvironmentProperty<Value>.ValueAccessor) {
    self.accessor = accessor
  }

  /// Initializes a new `EnvironmentProperty` instance with the specified key and optional source.
  ///
  /// - Parameters:
  ///   - key: The key associated with the environment value.
  ///   - source: The source of the environment values,
  ///   which defaults to `ProcessInfo.processInfo.environment`.
  public init(_ key: String, source: [String: String] = ProcessInfo.processInfo.environment) {
    self.init(accessor: .dictionary(source, key: key))
  }

  /// Initializes a new `EnvironmentProperty` instance
  /// with the specified key and optional source,
  /// where the key is a raw representable type.
  ///
  /// - Parameters:
  ///   - key: The key associated with the environment value, represented as a raw representable type.
  ///   - source: The source of the environment values,
  ///   which defaults to `ProcessInfo.processInfo.environment`.
  public init<KeyType: RawRepresentable>(
    _ key: KeyType,
    source: [String: String] = ProcessInfo.processInfo.environment
  ) where KeyType.RawValue == String {
    self.init(key.rawValue, source: source)
  }
}
