//
// DocumentContextual.swift
// Copyright (c) 2023 BrightDigit.
//

import Foundation

public protocol DocumentContextual {
  static var type: DocumentURL.DocumentType {
    get
  }

  static func fromURL(_ url: URL) throws -> Self
}
