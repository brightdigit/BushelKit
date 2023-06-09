//
// ManagerError.swift
// Copyright (c) 2023 BrightDigit.
//

import Foundation

public enum ManagerError: Error, LocalizedError {
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

  public var errorDescription: String? {
    description
  }
}
