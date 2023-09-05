//
// MockError.swift
// Copyright (c) 2023 BrightDigit.
//

import Foundation

protocol MockError: Equatable, Error {
  associatedtype T: Equatable

  var value: T { get }
}
