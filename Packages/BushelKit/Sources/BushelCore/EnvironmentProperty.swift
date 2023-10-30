//
// EnvironmentProperty.swift
// Copyright (c) 2023 BrightDigit.
//

import Foundation

@propertyWrapper
public struct EnvironmentProperty<Value: EnvironmentValue> {
  public var wrappedValue: Value {
    accessor.value
  }

  let accessor: ValueAccessor

  private init(accessor: EnvironmentProperty<Value>.ValueAccessor) {
    self.accessor = accessor
  }

  internal init(_ key: String, source: [String: String] = ProcessInfo.processInfo.environment) {
    self.init(accessor: .dictionary(source, key: key))
  }

  internal init<KeyType: RawRepresentable>(
    _ key: KeyType,
    source: [String: String] = ProcessInfo.processInfo.environment
  ) where KeyType.RawValue == String {
    self.init(key.rawValue, source: source)
  }
}
