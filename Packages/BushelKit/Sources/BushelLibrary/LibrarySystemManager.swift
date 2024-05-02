//
// LibrarySystemManager.swift
// Copyright (c) 2024 BrightDigit.
//

import BushelCore
import BushelLogging
import Foundation

public final class LibrarySystemManager: LibrarySystemManaging, Loggable, Sendable {
  public let fileTypeBasedOnURL: @Sendable (URL) -> FileType?

  let fileTypeMap: [FileType: VMSystemID]
  let implementations: [VMSystemID: any LibrarySystem]

  public var allAllowedFileTypes: [FileType] {
    implementations.values.flatMap(\.allowedContentTypes)
  }

  public init(
    _ implementations: [any LibrarySystem],
    fileTypeBasedOnURL: @escaping @Sendable (URL) -> FileType?
  ) {
    self.implementations = .init(
      uniqueKeysWithValues:
      implementations.map {
        ($0.id, $0)
      }
    )

    fileTypeMap = self.implementations.mapValues {
      $0.allowedContentTypes
    }
    .reduce(into: [FileType: VMSystemID]()) { partialResult, pair in
      for value in pair.value {
        partialResult[value] = pair.key
      }
    }

    Self.logger.debug("LibrarySystems Initialized: \(implementations.map(\.shortName))")
    Self.logger.debug("LibrarySystems Supported FileTypes: \(self.fileTypeMap.keys.map(\.utIdentifier))")

    self.fileTypeBasedOnURL = fileTypeBasedOnURL
  }

  public func resolveSystemFor(url: URL) -> VMSystemID? {
    guard let type = self.fileTypeBasedOnURL(url) else {
      Self.logger.error("Unknown path extension: \(url.pathExtension)")
      return nil
    }

    return fileTypeMap[type]
  }

  public func resolve(_ id: VMSystemID) -> any LibrarySystem {
    guard let implementations = implementations[id] else {
      Self.logger.critical("Unknown system: \(id.rawValue)")
      preconditionFailure("")
    }

    return implementations
  }
}
