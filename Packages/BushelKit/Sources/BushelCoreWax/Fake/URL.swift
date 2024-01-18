//
// URL.swift
// Copyright (c) 2024 BrightDigit.
//

import Foundation

public extension URL {
  // swiftlint:disable:next force_unwrapping
  static let bushelappURL: URL = .init(string: "https://getbushel.app")!
  // swiftlint:disable:next force_unwrapping
  static let homeDirectory = URL(string: NSHomeDirectory())!
  // swiftlint:disable:next force_unwrapping
  static let temporaryDir = URL(string: NSTemporaryDirectory())!
}
