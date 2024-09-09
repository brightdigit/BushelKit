//
// Localizable.swift
// Copyright (c) 2024 BrightDigit.
//

public import BushelCore

public import BushelLocalization

import Foundation

extension Localizable {
  public func localizedID(default defaultValue: any LocalizedID) -> any LocalizedID {
    let value = LocalizedStringID(rawValue: self.localizedStringIDRawValue)
    assert(value != nil)
    return value ?? defaultValue
  }
}

extension Optional where Wrapped: Localizable {
  public func localizedID(default defaultValue: any LocalizedID) -> any LocalizedID {
    let value = LocalizedStringID(rawValue: self.localizedStringIDRawValue)
    assert(value != nil)
    return value ?? defaultValue
  }
}
