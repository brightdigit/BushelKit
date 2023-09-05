//
// Icon.swift
// Copyright (c) 2023 BrightDigit.
//

import Foundation

protocol Icon {
  static var namespace: String { get }
  var name: String { get }
}

extension RawRepresentable where Self: Icon, RawValue == String {
  var name: String {
    [Self.namespace, rawValue].joined(separator: "/")
  }
}
