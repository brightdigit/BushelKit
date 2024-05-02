//
// DictionaryAttributeSet.swift
// Copyright (c) 2024 BrightDigit.
//

import Foundation

struct DictionaryAttributeSet: AttributeSet {
  let dictionary: [FileAttributeKey: any Sendable]

  func get<ValueType>(
    _ key: FileAttributeKey
  ) -> ValueType? where ValueType: BinaryInteger, ValueType: Sendable {
    self.dictionary[key] as? ValueType
  }
}
