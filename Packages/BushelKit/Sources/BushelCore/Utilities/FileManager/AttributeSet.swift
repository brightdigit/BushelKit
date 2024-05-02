//
// AttributeSet.swift
// Copyright (c) 2024 BrightDigit.
//

import Foundation

public protocol AttributeSet: Sendable {
  func get<ValueType: BinaryInteger & Sendable>(_ key: FileAttributeKey) -> ValueType?
}
