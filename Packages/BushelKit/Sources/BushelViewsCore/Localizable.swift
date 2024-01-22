//
// Localizable.swift
// Copyright (c) 2024 BrightDigit.
//

import BushelCore
import BushelLocalization
import Foundation

public extension Localizable {
  func localizedID(default defaultValue: any LocalizedID) -> any LocalizedID {
    let value = LocalizedStringID(rawValue: self.localizedStringIDRawValue)
    assert(value != nil)
    return value ?? defaultValue
  }
}

public extension Optional where Wrapped: Localizable {
  func localizedID(default defaultValue: any LocalizedID) -> any LocalizedID {
    let value = LocalizedStringID(rawValue: self.localizedStringIDRawValue)
    assert(value != nil)
    return value ?? defaultValue
  }
}
