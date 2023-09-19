//
// MockLocalizedError.swift
// Copyright (c) 2023 BrightDigit.
//

import Foundation

public protocol MockLocalizedError: LocalizedError, Equatable {
  associatedtype ErrorType: Equatable

  var value: ErrorType { get }
}
