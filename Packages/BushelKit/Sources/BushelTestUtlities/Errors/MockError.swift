//
// MockError.swift
// Copyright (c) 2023 BrightDigit.
//

import Foundation

public protocol MockError: Error, Equatable {
  associatedtype ErrorType: Equatable

  var value: ErrorType { get }
}
