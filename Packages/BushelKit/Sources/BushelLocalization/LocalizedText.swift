//
// LocalizedText.swift
// Copyright (c) 2024 BrightDigit.
//

import Foundation

public enum LocalizedText {
  case key(any LocalizedID)
  case text(String)

  func asString() -> String {
    switch self {
    case let .key(type):
      return Bundle.module.localizedString(forKey: .init(type.keyValue), value: nil, table: nil)

    case let .text(value):
      return value
    }
  }

  func key(_ stringID: LocalizedStringID) -> LocalizedText {
    .key(stringID)
  }
}
