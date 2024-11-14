//
//  UserDefaults.swift
//  BushelKit
//
//  Created by Leo Dion.
//  Copyright © 2024 BrightDigit.
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
public import RadiantKit

@available(*, deprecated,  message: "Should be moved to RadianKit")
extension UserDefaults {
  /// Retrieves a boolean value from the `UserDefaults` store, with a fallback default value.
  ///
  /// - Parameters:
  ///   - key: The key to use when retrieving the value from the `UserDefaults` store.
  ///   - defaultValue: The default value to return if the key does not exist in the `UserDefaults` store.
  /// - Returns: The boolean value associated with the specified key,
  /// or the provided default value if the key does not exist.
  public func bool(forKey key: String, defaultValue: Bool) -> Bool {
    guard self.object(forKey: key) == nil else {
      return self.bool(forKey: key)
    }

    return defaultValue
  }

  /// Retrieves a value from the `UserDefaults` store for a type
  ///  that conforms to the `AppStored` protocol, with a fallback default value.
  ///
  /// - Parameters:
  ///   - _: The type that conforms to the `AppStored` protocol.
  ///   - defaultValue: The default value to return if the key does not exist in the `UserDefaults` store.
  /// - Returns: The value associated with the specified type's key,
  /// or the provided default value if the key does not exist.
  public func value<AppStoredType: AppStored>(
    for _: AppStoredType.Type,
    defaultValue: AppStoredType.Value
  ) -> AppStoredType.Value where AppStoredType.Value == Bool {
    self.bool(forKey: AppStoredType.key, defaultValue: defaultValue)
  }

  /// Retrieves a value from the `UserDefaults` store for a type
  /// that conforms to the `DefaultWrapped` protocol, with a fallback default value.
  ///
  /// - Parameters:
  ///   - _: The type that conforms to the `DefaultWrapped` protocol.
  ///   - defaultValue: The default value to return if the key does not exist in the `UserDefaults` store.
  ///   Defaults to the type's `default` value if not provided.
  /// - Returns: The value associated with the specified type's key,
  /// or the provided default value if the key does not exist.
  public func value<AppStoredType: DefaultWrapped>(
    for _: AppStoredType.Type,
    defaultValue: AppStoredType.Value = AppStoredType.default
  ) -> AppStoredType.Value where AppStoredType.Value == Bool {
    self.bool(forKey: AppStoredType.key, defaultValue: defaultValue)
  }
}
