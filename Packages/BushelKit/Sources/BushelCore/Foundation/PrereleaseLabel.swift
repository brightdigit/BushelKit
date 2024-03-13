//
// PrereleaseLabel.swift
// Copyright (c) 2024 BrightDigit.
//

import Foundation

public struct PrereleaseLabel: Sendable {
  public let label: String
  public let baseNumber: Int

  public init(label: String, baseNumber: Int) {
    self.label = label
    self.baseNumber = baseNumber
  }
}

public extension PrereleaseLabel {
  enum Keys: String {
    case label = "Label"
    case base = "Base"
  }

  init?(dictionary: [String: Any]) {
    guard
      let label = dictionary[Keys.label.rawValue] as? String,
      let base = dictionary[Keys.base.rawValue] as? Int else {
      assertionFailure("Bundle InfoDictionary Missing Label and Base for Prerelease Info")
      return nil
    }
    self.init(label: label, baseNumber: base)
  }
}
