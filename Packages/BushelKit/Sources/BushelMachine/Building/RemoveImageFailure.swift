//
// RemoveImageFailure.swift
// Copyright (c) 2024 BrightDigit.
//

import Foundation

public enum RemoveImageFailure: CustomStringConvertible {
  case notFound
  case notSupported

  public var description: String {
    switch self {
    case .notFound:
      "Image Not Found"
    case .notSupported:
      "Removal Not Support by DB"
    }
  }
}
