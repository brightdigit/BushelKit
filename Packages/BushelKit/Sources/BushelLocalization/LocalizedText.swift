//
// LocalizedText.swift
// Copyright (c) 2023 BrightDigit.
//

import Foundation

public enum LocalizedText {
  case key(LocalizedStringID)
  case text(String)

  func asString() -> String {
    switch self {
    case let .key(type):
      return Bundle.module.localizedString(forKey: .init(type.keyValue), value: nil, table: nil)

    case let .text(value):
      return value
    }
  }
}
