//
// MockLocalizedError.swift
// Copyright (c) 2023 BrightDigit.
//

import Foundation

protocol MockLocalizedError: Equatable, LocalizedError {
  associatedtype ErrorType: Equatable

  var value: ErrorType { get }
}
