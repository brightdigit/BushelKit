//
// UbuntuLibrarySystemStub.swift
// Copyright (c) 2023 BrightDigit.
//

import BushelCore
import BushelLibrary
import Foundation

public struct UbuntuLibrarySystemStub: LibrarySystem {
  public var id: VMSystemID
  public var shortName: String = "ubuntu"
  public var allowedContentTypes: Set<FileType> = .init()

  public init(id: VMSystemID) {
    self.id = id
  }

  public func metadata(fromURL _: URL) async throws -> ImageMetadata {
    .ubuntu_22_10_0_21F125
  }

  public func label(fromMetadata metadata: OperatingSystemInstalled) -> MetadataLabel {
    .init(
      operatingSystemLongName: self.operatingSystemLongName(forOSMetadata: metadata),
      defaultName: self.defaultName(fromOSMetadata: metadata),
      imageName: self.imageName(forOSMetadata: metadata),
      systemName: self.shortName,
      versionName: self.codeNameFor(operatingSystemVersion: metadata.operatingSystemVersion)
    )
  }

  // MARK: - Helpers

  private func operatingSystemLongName(forOSMetadata metadata: OperatingSystemInstalled) -> String {
    let shortName = defaultName(fromOSMetadata: metadata)
    guard let buildVersion = metadata.buildVersion else {
      return shortName
    }
    return shortName.appending(" (\(buildVersion))")
  }

  private func defaultName(fromOSMetadata metadata: OperatingSystemInstalled) -> String {
    // swiftlint:disable:next line_length
    "\(self.shortName) \(codeNameFor(operatingSystemVersion: metadata.operatingSystemVersion)) \(metadata.operatingSystemVersion)"
  }

  private func codeNameFor(operatingSystemVersion _: OperatingSystemVersion) -> String {
    "Kinetic Kudu"
  }

  private func imageName(forOSMetadata metadata: OperatingSystemInstalled) -> String {
    "OSVersions/".appending(codeNameFor(operatingSystemVersion: metadata.operatingSystemVersion))
  }
}
