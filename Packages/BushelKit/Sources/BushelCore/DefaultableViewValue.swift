//
// DefaultableViewValue.swift
// Copyright (c) 2024 BrightDigit.
//

public protocol DefaultableViewValue: Codable, Hashable {
  static var `default`: Self { get }
}
