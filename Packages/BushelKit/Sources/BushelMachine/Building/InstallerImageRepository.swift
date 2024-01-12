//
// InstallerImageRepository.swift
// Copyright (c) 2024 BrightDigit.
//

import BushelCore
import Foundation

public protocol InstallerImageRepository {
  typealias Error = InstallerImageError

  func images(
    _ labelProvider: @escaping MetadataLabelProvider
  ) throws -> [any InstallerImage]

  func image(
    withID id: UUID,
    library: LibraryIdentifier?,
    _ labelProvider: @escaping MetadataLabelProvider
  ) throws -> (any InstallerImage)?

  @discardableResult
  func removeImage(_ image: InstallerImage) throws -> RemoveImageFailure?
}
