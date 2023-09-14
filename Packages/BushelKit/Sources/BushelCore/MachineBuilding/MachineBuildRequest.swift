//
// MachineBuildRequest.swift
// Copyright (c) 2023 BrightDigit.
//

import Foundation

public struct MachineBuildRequest: Codable, Hashable {
  public let restoreImage: InstallerImageIdentifier?

  public init(restoreImage: InstallerImageIdentifier? = nil) {
    self.restoreImage = restoreImage
  }
}
