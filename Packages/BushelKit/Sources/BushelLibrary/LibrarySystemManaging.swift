//
// LibrarySystemManaging.swift
// Copyright (c) 2023 BrightDigit.
//

import BushelCore
import BushelLogging
import Foundation

public protocol LibrarySystemManaging: LoggerCategorized {
  func resolve(_ id: VMSystemID) -> any LibrarySystem
  func resolveSystemFor(url: URL) -> VMSystemID?
  var allAllowedFileTypes: [FileType] { get }
}

public extension LibrarySystemManaging where Self: LoggerCategorized {
  static var loggingCategory: BushelLogging.Loggers.Category {
    .library
  }

  typealias LoggersType = BushelLogging.Loggers
}

public extension LibrarySystemManaging {
  func resolve(_ url: URL) throws -> any LibrarySystem {
    guard let systemID = resolveSystemFor(url: url) else {
      let error = VMSystemError.unknownSystemBasedOn(url)
      Self.logger.error("Unable able to resolve system for url \(url): \(error.localizedDescription)")
      throw error
    }

    return resolve(systemID)
  }

  func labelForSystem(_ id: VMSystemID, metadata: ImageMetadata) -> MetadataLabel {
    let system = self.resolve(id)
    return .init(
      operatingSystemLongName: system.operatingSystemLongName(for: metadata),
      defaultName: system.defaultName(fromMetadata: metadata),
      imageName: system.imageName(for: metadata)
    )
  }
}
