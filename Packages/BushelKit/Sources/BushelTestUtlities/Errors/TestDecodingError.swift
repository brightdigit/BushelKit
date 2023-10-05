//
// TestDecodingError.swift
// Copyright (c) 2023 BrightDigit.
//

import Foundation

public enum TestDecodingError: String, MockError {
  case dataEncoding

  public var value: String { self.rawValue }
}
