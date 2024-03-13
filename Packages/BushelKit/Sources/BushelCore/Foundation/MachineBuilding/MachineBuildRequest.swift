//
// MachineBuildRequest.swift
// Copyright (c) 2024 BrightDigit.
//

import Foundation

public struct MachineBuildRequest: Codable, Hashable, Sendable {
  public let restoreImage: InstallerImageIdentifier?

  public init(restoreImage: InstallerImageIdentifier? = nil) {
    self.restoreImage = restoreImage
  }
}
