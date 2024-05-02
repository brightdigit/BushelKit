//
// Randomizable.swift
// Copyright (c) 2024 BrightDigit.
//

import Foundation

public protocol Randomizable: Comparable {
  static func random(in range: ClosedRange<Self>) -> Self
}

extension Int: Randomizable {}
