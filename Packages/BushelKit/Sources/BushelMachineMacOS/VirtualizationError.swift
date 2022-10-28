//
// VirtualizationError.swift
// Copyright (c) 2023 BrightDigit.
//

import Foundation

enum VirtualizationError: Error, LocalizedError {
  case undefinedType(String, Any?)

  var errorDescription: String? {
    guard case let .undefinedType(string, any) = self else {
      return nil
    }

    return string
  }
}
