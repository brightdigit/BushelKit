//
// MockError.swift
// Copyright (c) 2024 BrightDigit.
//

import Foundation

public protocol MockError: Error, Equatable {
  associatedtype ErrorType: Equatable

  var value: ErrorType { get }
}
