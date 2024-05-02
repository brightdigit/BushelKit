//
// MacOSVirtualization.swift
// Copyright (c) 2024 BrightDigit.
//

import BushelCore
import Foundation

public enum MacOSVirtualization: Sendable {
  public static let allowedContentTypes: Set<FileType> = Set(FileType.ipswTypes)

  public static let shortName = "macOS"

  public static var ipswFileExtension: String {
    FileType.ipswFileExtension
  }

  public static func operatingSystemLongName(for metadata: any OperatingSystemInstalled) -> String {
    let shortName = operatingSystemShortName(for: metadata)
    guard let buildVersion = metadata.buildVersion else {
      return shortName
    }
    return shortName.appending(" (\(buildVersion))")
  }

  public static func imageNameWithDefault(
    forMajorVersion majorVersion: Int,
    _ defaultCodeName: String? = nil
  ) -> String {
    let defaultCodeName = defaultCodeName ?? majorVersion.description
    let codeName = self.codeNameFor(majorVersion: majorVersion, withDefault: defaultCodeName)
    return "OSVersions/\(codeName)"
  }

  public static func imageName(forMajorVersion majorVersion: Int) -> String? {
    guard let codeName = codeNameFor(majorVersion: majorVersion) else {
      assertionFailure("Missing Code Name for v\(majorVersion)")
      return nil
    }
    return "OSVersions/\(codeName)"
  }

  public static func imageName(for metadata: any OperatingSystemInstalled) -> String {
    let majorVersion = metadata.operatingSystemVersion.majorVersion
    return imageNameWithDefault(forMajorVersion: majorVersion)
  }

  public static func codeNameFor(majorVersion: Int) -> String? {
    OperatingSystemVersion.macOSReleaseName(majorVersion: majorVersion)
  }

  public static func codeNameWithDefaultFor(majorVersion: Int) -> String {
    self.codeNameFor(majorVersion: majorVersion, withDefault: majorVersion.description)
  }

  public static func codeNameFor(majorVersion: Int, withDefault defaultName: String) -> String {
    OperatingSystemVersion.macOSReleaseName(majorVersion: majorVersion) ?? defaultName
  }

  public static func operatingSystemShortName(for metadata: any OperatingSystemInstalled) -> String {
    // swiftlint:disable:next line_length
    "macOS \(codeNameWithDefaultFor(majorVersion: metadata.operatingSystemVersion.majorVersion)) \(metadata.operatingSystemVersion)"
  }

  public static func defaultName(fromMetadata metadata: any OperatingSystemInstalled) -> String {
    operatingSystemShortName(for: metadata)
  }

  public static func label(fromMetadata metadata: any OperatingSystemInstalled) -> MetadataLabel {
    .init(
      operatingSystemLongName: self.operatingSystemLongName(for: metadata),
      defaultName: self.defaultName(fromMetadata: metadata),
      imageName: self.imageName(for: metadata),
      systemName: self.shortName,
      versionName: MacOSVirtualization.codeNameWithDefaultFor(
        majorVersion: metadata.operatingSystemVersion.majorVersion
      )
    )
  }
}
