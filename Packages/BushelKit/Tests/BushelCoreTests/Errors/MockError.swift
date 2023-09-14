//
// MockError.swift
// Copyright (c) 2023 BrightDigit.
//

import Foundation

protocol MockError: Equatable, Error {
  associatedtype ErrorType: Equatable

  var value: ErrorType { get }
}
