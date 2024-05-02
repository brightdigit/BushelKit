//
// DependencyResolutionFailures.swift
// Copyright (c) 2024 BrightDigit.
//

import Foundation

// MARK: - DependencyResolutionFailures

public struct DependencyResolutionFailures: Codable, Equatable, Sendable {
  enum CodingKeys: String, CodingKey {
    case noKextsFoundForTheseLibraries = "No kexts found for these libraries"
  }

  public let noKextsFoundForTheseLibraries: [String]

  public init(noKextsFoundForTheseLibraries: [String]) {
    self.noKextsFoundForTheseLibraries = noKextsFoundForTheseLibraries
  }
}
