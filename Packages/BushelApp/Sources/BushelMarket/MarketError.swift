//
// MarketError.swift
// Copyright (c) 2024 BrightDigit.
//

import Foundation

public enum MarketError: Error, Sendable {
  case networkError(URLError)
  case unknownError(any Error)
}
