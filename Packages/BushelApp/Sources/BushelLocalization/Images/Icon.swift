//
// Icon.swift
// Copyright (c) 2024 BrightDigit.
//

import Foundation

public protocol Icon {
  static var namespace: String { get }
  var name: String { get }
}

extension RawRepresentable where Self: Icon, RawValue == String {
  public var name: String {
    [Self.namespace, rawValue].joined(separator: "/")
  }
}
