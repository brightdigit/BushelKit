//
// DefaultableViewValue.swift
// Copyright (c) 2023 BrightDigit.
//

public protocol DefaultableViewValue: Codable, Hashable {
  static var `default`: Self { get }
}
