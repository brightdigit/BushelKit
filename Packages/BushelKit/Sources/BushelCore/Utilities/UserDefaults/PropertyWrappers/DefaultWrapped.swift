//
// DefaultWrapped.swift
// Copyright (c) 2024 BrightDigit.
//

import Foundation

public protocol DefaultWrapped: AppStored {
  static var `default`: Value { get }
}
