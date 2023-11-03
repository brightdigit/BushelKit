//
// MacOSVirtualization.swift
// Copyright (c) 2023 BrightDigit.
//

import BushelCore
import Foundation

public enum MacOSVirtualization {
  public static let allowedContentTypes: Set<FileType> = Set(FileType.ipswTypes)

  public static func operatingSystemLongName(for metadata: OperatingSystemInstalled) -> String {
    let shortName = operatingSystemShortName(for: metadata)
    guard let buildVersion = metadata.buildVersion else {
      return shortName
    }
    return shortName.appending(" (\(buildVersion))")
  }

  public static func imageName(for metadata: OperatingSystemInstalled) -> String {
    "OSVersions/".appending(codeNameFor(operatingSystemVersion: metadata.operatingSystemVersion))
  }

  public static func codeNameFor(operatingSystemVersion: OperatingSystemVersion) -> String {
    operatingSystemVersion.macOSReleaseName ?? operatingSystemVersion.majorVersion.description
  }

  public static func operatingSystemShortName(for metadata: OperatingSystemInstalled) -> String {
    // swiftlint:disable:next line_length
    "macOS \(codeNameFor(operatingSystemVersion: metadata.operatingSystemVersion)) \(metadata.operatingSystemVersion)"
  }

  public static func defaultName(fromMetadata metadata: OperatingSystemInstalled) -> String {
    operatingSystemShortName(for: metadata)
  }
}
