//
// InstallerImageRepository.swift
// Copyright (c) 2023 BrightDigit.
//

import BushelCore
import Foundation

public protocol InstallerImageRepository {
  typealias Error = InstallerImageError

  func image(
    _ labelProvider: @escaping MetadataLabelProvider
  ) throws -> [any InstallerImage]

  func image(
    withID id: UUID,
    library: LibraryIdentifier?,
    _ labelProvider: @escaping MetadataLabelProvider
  ) throws -> (any InstallerImage)?
}
