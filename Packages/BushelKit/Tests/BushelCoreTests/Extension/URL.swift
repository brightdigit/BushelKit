//
// URL.swift
// Copyright (c) 2023 BrightDigit.
//

import Foundation

extension URL {
  static let homeDirectory = URL(string: NSHomeDirectory())!
  static let temporaryDirectory = URL(string: NSTemporaryDirectory())!
}
