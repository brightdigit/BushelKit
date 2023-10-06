//
// String.swift
// Copyright (c) 2023 BrightDigit.
//

import Foundation

// MARK: - RestoreImageIdentifier

public extension String {
  // swiftlint:disable:next line_length
  static let restoreImageIdentiferSample: Self = "C90C2C17-7CA1-466C-93C0-D73591D65C94:2480CC13-8CFE-4CB6-9FBF-FFD2157B8995"
  static let imageIDSample: Self = "2480CC13-8CFE-4CB6-9FBF-FFD2157B8995"
  static let libraryBookmarkIDSample: Self = UUID.bookmarkIDSample.uuidString

  static let lowerCaseAlphaNumberic = "abcdefghijklmnopqrstuvwxyz0123456789"

  static func randomLowerCaseAlphaNumberic(ofLength length: Int = 32) -> String {
    String((1 ... length).map { _ in
      // swiftlint:disable:next force_unwrapping
      lowerCaseAlphaNumberic.randomElement()!
    })
  }
}
