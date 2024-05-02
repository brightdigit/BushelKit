//
// SpextHasAllDependenciesErrors.swift
// Copyright (c) 2024 BrightDigit.
//

import Foundation

// MARK: - SpextHasAllDependenciesErrors

public struct SpextHasAllDependenciesErrors: Codable, Equatable, Sendable {
  enum CodingKeys: String, CodingKey {
    case dependencyResolutionFailures = "Dependency Resolution Failures"
  }

  public let dependencyResolutionFailures: DependencyResolutionFailures

  public init(dependencyResolutionFailures: DependencyResolutionFailures) {
    self.dependencyResolutionFailures = dependencyResolutionFailures
  }
}
