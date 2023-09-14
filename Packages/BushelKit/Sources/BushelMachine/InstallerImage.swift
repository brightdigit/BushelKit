//
// InstallerImage.swift
// Copyright (c) 2023 BrightDigit.
//

import BushelCore
import BushelLogging
import Foundation

public protocol InstallerImage: OperatingSystemInstalled {
  typealias Metadata = InstallerImageMetadata
  var libraryID: LibraryIdentifier? { get }
  var imageID: UUID { get }
  var metadata: Metadata { get }
  func getURL() throws -> URL
}

public extension InstallerImage {
  var operatingSystemVersion: OperatingSystemVersion {
    metadata.operatingSystem
  }

  var buildVersion: String {
    metadata.buildVersion
  }
}

public extension InstallerImage where Self: LoggerCategorized {
  static var loggingCategory: BushelLogging.Loggers.Category {
    .library
  }
}

extension InstallerImage {
  var indentifier: InstallerImageIdentifier {
    InstallerImageIdentifier(imageID: imageID, libraryID: libraryID)
  }
}
