//
// GlobalizedError.swift
// Copyright (c) 2023 BrightDigit.
//

import Foundation

public struct GlobalizedError: LocalizedError {
  let innerError: Error

  public var errorDescription: String? {
    (innerError as? LocalizedError)?.errorDescription ?? innerError.localizedDescription
  }

  public init(_ innerError: Error) {
    self.innerError = innerError
  }
}
