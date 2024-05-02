//
// Progress.swift
// Copyright (c) 2024 BrightDigit.
//

import Foundation

public enum Progress {
  case icon
  case title
  case view

  public var identifier: String {
    switch self {
    case .icon:
      "progress-icon"
    case .title:
      "progress-title"
    case .view:
      "progress-view"
    }
  }
}
