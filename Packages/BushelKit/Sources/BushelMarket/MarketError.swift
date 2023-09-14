//
// MarketError.swift
// Copyright (c) 2023 BrightDigit.
//

import Foundation

public enum MarketError: Error {
  case networkError(URLError)
  case unknownError(Error)
}
