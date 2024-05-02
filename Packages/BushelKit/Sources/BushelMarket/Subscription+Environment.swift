//
// Subscription+Environment.swift
// Copyright (c) 2024 BrightDigit.
//

import Foundation

public extension Subscription {
  enum Environment: Sendable {
    case production

    case sandbox

    case xcode

    case unknown(rawValue: String)
  }
}
