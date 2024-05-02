//
// InstallerImageRepository.swift
// Copyright (c) 2024 BrightDigit.
//

import BushelCore
import Foundation

public protocol InstallerImageRepository: Sendable {
  typealias Error = InstallerImageError

  func images(
    _ labelProvider: @escaping MetadataLabelProvider
  ) async throws -> [any InstallerImage]

  func image(
    withID id: UUID,
    library: LibraryIdentifier?,
    _ labelProvider: @escaping MetadataLabelProvider
  ) async throws -> (any InstallerImage)?

  @discardableResult
  func removeImage(_ image: any InstallerImage) async throws -> RemoveImageFailure?
}
