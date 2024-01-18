//
// EnvironmentProperty+ValueAccessor.swift
// Copyright (c) 2024 BrightDigit.
//

import Foundation

extension EnvironmentProperty {
  enum ValueAccessor {
    case dictionary([String: String], key: String)
    case value(Value)

    var value: Value {
      switch self {
      case let .value(value):
        return value

      case let .dictionary(dictionary, key: key):
        return dictionary[key].flatMap(Value.init) ?? Value.default
      }
    }

    var dictionary: [String: String]? {
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
