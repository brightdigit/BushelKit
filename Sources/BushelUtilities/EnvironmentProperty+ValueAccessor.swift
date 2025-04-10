//
//  EnvironmentProperty+ValueAccessor.swift
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

extension EnvironmentProperty {
  internal enum ValueAccessor: Sendable {
    /// Represents a value stored in a dictionary, with a corresponding key.
    case dictionary([String: String], key: String)
    /// Represents a directly stored value.
    case value(Value)

    /// The value represented by the `ValueAccessor`.
    internal var value: Value {
      switch self {
      case let .value(value):
        value

      case let .dictionary(dictionary, key: key):
        dictionary[key].flatMap(Value.init) ?? Value.default
      }
    }

    /// The dictionary represented by the `ValueAccessor`, if applicable.
    internal var dictionary: [String: String]? {
      guard case let .dictionary(source, key: key) = self else {
        return nil
      }
      guard let value = source[key] else {
        return nil
      }

      return [key: value]
    }
  }
}
