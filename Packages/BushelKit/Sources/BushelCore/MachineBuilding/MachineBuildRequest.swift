//
// MachineBuildRequest.swift
// Copyright (c) 2023 BrightDigit.
//

import Foundation

public struct MachineBuildRequest: Codable, Hashable {
  public init(restoreImage: InstallerImageIdentifier? = nil) {
    self.restoreImage = restoreImage
  }

  public let restoreImage: InstallerImageIdentifier?
}
