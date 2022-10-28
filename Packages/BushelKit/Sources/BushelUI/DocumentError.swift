//
// DocumentError.swift
// Copyright (c) 2023 BrightDigit.
//

import Foundation

enum DocumentError: Error, LocalizedError, CustomStringConvertible {
  case undefinedType(String, Any?)
  case innerError(Error, String?, Any?)

  var description: String {
    switch self {
    case let .undefinedType(description, _):
      return description

    case let .innerError(error, description, _):
      return error.localizedDescription
    }
  }

  var errorDescription: String? {
    description
  }
}
