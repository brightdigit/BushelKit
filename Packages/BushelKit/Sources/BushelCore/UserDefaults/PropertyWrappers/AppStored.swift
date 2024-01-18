//
// AppStored.swift
// Copyright (c) 2024 BrightDigit.
//

import Foundation

public protocol AppStored {
  associatedtype Value
  static var keyType: KeyType { get }
  static var key: String { get }
}

public extension AppStored {
  static var key: String {
    switch self.keyType {
    case .describing:
      String(describing: Self.self)

    case .reflecting:
      String(reflecting: Self.self).components(separatedBy: ".").dropFirst().joined(separator: ".")
    }
  }

  static var keyType: KeyType {
    .describing
  }
}
