//
// MockLocalizedError.swift
// Copyright (c) 2024 BrightDigit.
//

import Foundation

public protocol MockLocalizedError: LocalizedError, Equatable {
  associatedtype ErrorType: Equatable

  var value: ErrorType { get }
}
