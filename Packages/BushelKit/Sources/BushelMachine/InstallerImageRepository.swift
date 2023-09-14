//
// InstallerImageRepository.swift
// Copyright (c) 2023 BrightDigit.
//

import BushelCore
import Foundation

public protocol InstallerImageRepository {
  typealias Error = InstallerImageError

  func installImages(
    _ labelProvider: @escaping MetadataLabelProvider
  ) throws -> [any InstallerImage]

  func installImage(
    withID id: UUID,
    library: LibraryIdentifier?,
    _ labelProvider: @escaping MetadataLabelProvider
  ) throws -> (any InstallerImage)?
}
