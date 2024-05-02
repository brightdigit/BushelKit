//
// ReleaseMetadata.swift
// Copyright (c) 2024 BrightDigit.
//

import BushelCore
import BushelMachine
import Foundation

public struct ReleaseMetadata: Identifiable, Equatable {
  public let metadata: any InstallerRelease
  public let images: [any InstallerImage]

  public var id: Int {
    metadata.majorVersion
  }

  public var isCustom: Bool {
    self.metadata.isCustom
  }

  internal init(metadata: any InstallerRelease, images: [any InstallerImage]) {
    self.metadata = metadata
    self.images = images
  }

  public static func == (lhs: ReleaseMetadata, rhs: ReleaseMetadata) -> Bool {
    lhs.metadata.isEqual(to: rhs.metadata)
  }
}
