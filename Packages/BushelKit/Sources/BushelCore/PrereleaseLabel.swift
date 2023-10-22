//
// PrereleaseLabel.swift
// Copyright (c) 2023 BrightDigit.
//

import Foundation

public struct PrereleaseLabel {
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
      #warning("shendy-note: let's have a message here for what was expected")
      assertionFailure()
      return nil
    }
    self.init(label: label, baseNumber: base)
  }
}
