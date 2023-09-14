//
// URL.swift
// Copyright (c) 2023 BrightDigit.
//

import Foundation

// swiftlint:disable force_unwrapping
extension URL {
  static let homeDirectory = URL(string: NSHomeDirectory())!
  static let temporaryDirectory = URL(string: NSTemporaryDirectory())!
}

// swiftlint:enable force_unwrapping
