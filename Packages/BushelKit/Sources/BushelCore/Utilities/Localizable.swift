//
// Localizable.swift
// Copyright (c) 2024 BrightDigit.
//

import Foundation

public protocol Localizable: Hashable {
  static var emptyLocalizedStringID: String { get }
  static var defaultLocalizedStringID: String { get }
  static var localizedStringIDMapping: [Self: String] { get }
}

public extension Localizable {
  static var emptyLocalizedStringID: String {
    ""
  }

  static var defaultLocalizedStringID: String {
    emptyLocalizedStringID
  }

  var localizedStringIDRawValue: String {
    let string = Self.localizedStringIDMapping[self]
    assert(string != nil)
    return string ?? ""
  }
}

public extension Optional where Wrapped: Localizable {
  var localizedStringIDRawValue: String {
    guard let value = self else {
      return Wrapped.defaultLocalizedStringID
    }
    let string = Wrapped.localizedStringIDMapping[value]
    assert(string != nil)
    return string ?? ""
  }
}
