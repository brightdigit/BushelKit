//
// DefaultWrapped.swift
// Copyright (c) 2023 BrightDigit.
//

import Foundation

public protocol DefaultWrapped: AppStored {
  static var `default`: Value { get }
}
