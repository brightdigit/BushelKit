//
// MachineError.swift
// Copyright (c) 2023 BrightDigit.
//

import Foundation

enum MachineError: Error, LocalizedError {
  case undefinedType(String, Any?)

  case innerError(Error, String?, Any?)

  var description: String {
    switch self {
    case let .undefinedType(description, _):
      return description

    case let .innerError(error, _, _):
      return error.localizedDescription
    }
  }

  var errorDescription: String? {
    description
  }
}
