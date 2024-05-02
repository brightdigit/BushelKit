//
// TestDecodingError.swift
// Copyright (c) 2024 BrightDigit.
//

import Foundation

public enum TestDecodingError: String, MockError {
  case dataEncoding

  public var value: String { self.rawValue }
}
