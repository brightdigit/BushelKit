//
// Subscription+Environment.swift
// Copyright (c) 2024 BrightDigit.
//

import Foundation

extension Subscription {
  public enum Environment: Sendable {
    case production

    case sandbox

    case xcode

    case unknown(rawValue: String)
  }
}
