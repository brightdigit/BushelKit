//
// ReleaseSelected.swift
// Copyright (c) 2024 BrightDigit.
//

import Foundation

public enum ReleaseSelected {
  case version(ReleaseMetadata)
  case custom
  case none
}

public extension ReleaseSelected {
  init(metadata: ReleaseMetadata) {
    if metadata.isCustom {
      self = .custom
    } else {
      self = .version(metadata)
    }
  }
}
