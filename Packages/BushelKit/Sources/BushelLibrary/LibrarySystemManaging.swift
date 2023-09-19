//
// LibrarySystemManaging.swift
// Copyright (c) 2023 BrightDigit.
//

import BushelCore
import BushelLogging
import Foundation

public protocol LibrarySystemManaging: LoggerCategorized {
  var allAllowedFileTypes: [FileType] { get }
  func resolve(_ id: VMSystemID) -> any LibrarySystem
  func resolveSystemFor(url: URL) -> VMSystemID?
}

public extension LibrarySystemManaging where Self: LoggerCategorized {
  static var loggingCategory: BushelLogging.Loggers.Category {
    .library
  }
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

  func labelForSystem(_ id: VMSystemID, metadata: OperatingSystemInstalled) -> MetadataLabel {
    let system = self.resolve(id)
    return system.label(fromMetadata: metadata)
  }
}
