//
// PaywallConfiguration.swift
// Copyright (c) 2024 BrightDigit.
//

public import Foundation

public struct PaywallConfiguration: Sendable {
  public nonisolated static let shared: PaywallConfiguration = .init()
  public let maximumNumberOfFreeSnapshots = 4
  private init() {}
}
