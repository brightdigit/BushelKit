//
// MarketError.swift
// Copyright (c) 2024 BrightDigit.
//

import Foundation

public enum MarketError: Error {
  case networkError(URLError)
  case unknownError(Error)
}
