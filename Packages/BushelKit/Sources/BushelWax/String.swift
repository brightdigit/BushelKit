//
// String.swift
// Copyright (c) 2023 BrightDigit.
//

import Foundation

public extension String {
  static let lowerCaseAlphaNumberic = "abcdefghijklmnopqrstuvwxyz0123456789"

  static func randomLowerCaseAlphaNumberic(ofLength length: Int = 32) -> String {
    String((1 ... length).map { _ in
      // swiftlint:disable:next force_unwrapping
      lowerCaseAlphaNumberic.randomElement()!
    })
  }
}
