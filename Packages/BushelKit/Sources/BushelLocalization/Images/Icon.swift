//
// Icon.swift
// Copyright (c) 2024 BrightDigit.
//

import Foundation

public protocol Icon {
  static var namespace: String { get }
  var name: String { get }
}

public extension RawRepresentable where Self: Icon, RawValue == String {
  var name: String {
    [Self.namespace, rawValue].joined(separator: "/")
  }
}
