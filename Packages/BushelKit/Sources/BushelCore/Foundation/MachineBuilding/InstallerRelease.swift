//
// InstallerRelease.swift
// Copyright (c) 2024 BrightDigit.
//

import Foundation

public protocol InstallerRelease: Sendable, Identifiable, Equatable {
  var versionName: String { get }
  var releaseName: String { get }
  var imageName: String { get }
  var majorVersion: Int { get }
}

extension InstallerRelease {
  public static func == (lhs: Self, rhs: Self) -> Bool {
    lhs.id == rhs.id
  }

  package func isEqual(to other: some InstallerRelease) -> Bool {
    guard let otherID = other.id as? Self.ID else {
      return false
    }

    return id == otherID
  }
}
