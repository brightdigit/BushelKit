//
// MacOSLibrarySystemStub.swift
// Copyright (c) 2024 BrightDigit.
//

import BushelCore
import BushelLibrary
import Foundation

public struct MacOSLibrarySystemStub: LibrarySystem {
  private static let codeNames: [Int: String] = [
    11: "Big Sur",
    12: "Monterey",
    13: "Ventura",
    14: "Sonoma"
  ]

  public var id: VMSystemID
  public var shortName: String = "macOS"
  public var allowedContentTypes: Set<FileType> = .init()
  public var releaseCollectionMetadata: any BushelCore.ReleaseCollectionMetadata {
    fatalError("Not Implemented")
  }

  public init(id: VMSystemID) {
    self.id = id
  }

  public func metadata(fromURL _: URL) async throws -> ImageMetadata {
    .macOS_12_6_0_21G115
  }

  public func label(fromMetadata metadata: any OperatingSystemInstalled) -> MetadataLabel {
    .init(
      operatingSystemLongName: self.operatingSystemLongName(forOSMetadata: metadata),
      defaultName: self.defaultName(fromOSMetadata: metadata),
      imageName: self.imageName(forOSMetadata: metadata),
      systemName: "macOS",
      versionName: self.codeNameFor(operatingSystemVersion: metadata.operatingSystemVersion)
    )
  }

  // MARK: - Helpers

  private func operatingSystemLongName(forOSMetadata metadata: any OperatingSystemInstalled) -> String {
    let shortName = defaultName(fromOSMetadata: metadata)
    guard let buildVersion = metadata.buildVersion else {
      return shortName
    }
    return shortName.appending(" (\(buildVersion))")
  }

  private func defaultName(fromOSMetadata metadata: any OperatingSystemInstalled) -> String {
    // swiftlint:disable:next line_length
    "macOS \(codeNameFor(operatingSystemVersion: metadata.operatingSystemVersion)) \(metadata.operatingSystemVersion)"
  }

  private func codeNameFor(operatingSystemVersion: OperatingSystemVersion) -> String {
    Self.codeNames[operatingSystemVersion.majorVersion] ?? operatingSystemVersion.majorVersion.description
  }

  private func imageName(forOSMetadata metadata: any OperatingSystemInstalled) -> String {
    "OSVersions/".appending(codeNameFor(operatingSystemVersion: metadata.operatingSystemVersion))
  }
}
