//
// String.swift
// Copyright (c) 2022 BrightDigit.
//

import Foundation

extension String {
  // swiftlint:disable:next force_try
  static let pattern: NSRegularExpression = try! NSRegularExpression(
    pattern: "[A-Z][a-z,\\d]*",
    options: []
  )

  func camelCaseTosnake_case() -> String {
    let input: NSString = (self as NSString)
      .replacingCharacters(
        in: NSRange(location: 0, length: 1),
        with: (self as NSString).substring(to: 1).capitalized
      ) as NSString
    var array = [String]()
    let matches = Self.pattern.matches(
      in: input as String,
      options: [],
      range: NSRange(location: 0, length: input.length)
    )
    for match in matches {
      for index in 0 ..< match.numberOfRanges {
        array.append(input.substring(with: match.range(at: index)).lowercased())
      }
    }
    return array.joined(separator: "_")
  }
}
