//
// InstallerImage.swift
// Copyright (c) 2024 BrightDigit.
//

import BushelCore
import BushelLogging
import Foundation

public protocol InstallerImage: OperatingSystemInstalled, Sendable {
  typealias Metadata = InstallerImageMetadata
  var libraryID: LibraryIdentifier? { get }
  var imageID: UUID { get }
  var metadata: Metadata { get }
  func getURL() async throws -> URL
}

public extension InstallerImage {
  var operatingSystemVersion: OperatingSystemVersion {
    metadata.operatingSystem
  }

  var buildVersion: String? {
    metadata.buildVersion
  }

  func getConfigurationRange(from manager: any MachineSystemManaging) -> ConfigurationRange {
    let manager = manager.resolve(self.metadata.vmSystemID)
    return manager.configurationRange(for: self)
  }
}

public extension InstallerImage where Self: Loggable {
  static var loggingCategory: BushelLogging.Category {
    .library
  }
}

extension InstallerImage {
  var indentifier: InstallerImageIdentifier {
    InstallerImageIdentifier(imageID: imageID, libraryID: libraryID)
  }
}
