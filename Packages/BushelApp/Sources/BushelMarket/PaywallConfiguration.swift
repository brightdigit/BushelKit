//
// PaywallConfiguration.swift
// Copyright (c) 2024 BrightDigit.
//

import Foundation

public struct PaywallConfiguration: Sendable {
  public nonisolated static let shared: PaywallConfiguration = .init()
  public let maximumNumberOfFreeSnapshots = 4
  private init() {}
}
