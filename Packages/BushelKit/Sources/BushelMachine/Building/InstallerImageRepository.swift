//
// InstallerImageRepository.swift
// Copyright (c) 2023 BrightDigit.
//

import BushelCore
import Foundation

public enum RemoveImageFailure: CustomStringConvertible {
  case notFound
  case notSupported

  public var description: String {
    switch self {
    case .notFound:
      "Image Not Found"
    case .notSupported:
      "Removal Not Support by DB"
    }
  }
}

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
