//
//  MacOSVirtualization.swift
//  BushelKit
//
//  Created by Leo Dion.
//  Copyright © 2025 BrightDigit.
//
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the “Software”), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or
//  sell copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
//

internal import BushelDocs
public import BushelFoundation
internal import Foundation
public import OSVer
public import RadiantDocs

/// Namespace for macOS-specific virtualization helpers built on Apple's Virtualization framework.
public enum MacOSVirtualization: Sendable {
  /// The content types accepted for macOS restore images.
  public static let allowedContentTypes: Set<FileType> = Set(FileType.ipswTypes)

  /// The short display name for the macOS operating system.
  public static let shortName = "macOS"

  /// The file extension used by IPSW restore images.
  public static var ipswFileExtension: String {
    FileType.ipswFileExtension
  }

  /// Returns the long, user-facing operating system name for the given metadata.
  ///
  /// - Parameter metadata: The installed operating system metadata.
  /// - Returns: The operating system name, including the build version when available.
  public static func operatingSystemLongName(for metadata: any OperatingSystemInstalled) -> String {
    let shortName = defaultName(fromMetadata: metadata)
    guard let buildVersion = metadata.buildVersion else {
      return shortName
    }
    return shortName.appending(" (\(buildVersion))")
  }

  /// Returns the asset image name for a major macOS version, falling back to a default code name.
  ///
  /// - Parameters:
  ///   - majorVersion: The major macOS version number.
  ///   - defaultCodeName: A code name to use when none is known; defaults to the version number.
  /// - Returns: The image asset path for the release.
  public static func imageNameWithDefault(
    forMajorVersion majorVersion: Int,
    _ defaultCodeName: String? = nil
  ) -> String {
    let defaultCodeName = defaultCodeName ?? majorVersion.description
    let codeName = self.codeNameFor(majorVersion: majorVersion, withDefault: defaultCodeName)
    return "OSVersions/\(codeName)"
  }

  /// Returns the asset image name for a major macOS version, if a code name is known.
  ///
  /// - Parameter majorVersion: The major macOS version number.
  /// - Returns: The image asset path, or `nil` when no code name exists for the version.
  public static func imageName(forMajorVersion majorVersion: Int) -> String? {
    guard let codeName = codeNameFor(majorVersion: majorVersion) else {
      assertionFailure("Missing Code Name for v\(majorVersion)")
      return nil
    }
    return "OSVersions/\(codeName)"
  }

  /// Returns the asset image name for the operating system described by the metadata.
  ///
  /// - Parameter metadata: The installed operating system metadata.
  /// - Returns: The image asset path for the metadata's major version.
  public static func imageName(for metadata: any OperatingSystemInstalled) -> String {
    let majorVersion = metadata.operatingSystemVersion.majorVersion
    return imageNameWithDefault(forMajorVersion: majorVersion)
  }

  /// Returns the macOS release code name for a major version, if one is known.
  ///
  /// - Parameter majorVersion: The major macOS version number.
  /// - Returns: The release code name, or `nil` when unknown.
  public static func codeNameFor(majorVersion: Int) -> String? {
    OSVer.macOSReleaseName(majorVersion: majorVersion)
  }

  /// Returns the macOS release code name for a major version, defaulting to the version number.
  ///
  /// - Parameter majorVersion: The major macOS version number.
  /// - Returns: The release code name, or the version number when unknown.
  public static func codeNameWithDefaultFor(majorVersion: Int) -> String {
    self.codeNameFor(majorVersion: majorVersion, withDefault: majorVersion.description)
  }

  /// Returns the macOS release code name for a major version, using the provided fallback.
  ///
  /// - Parameters:
  ///   - majorVersion: The major macOS version number.
  ///   - defaultName: The value to return when no code name is known.
  /// - Returns: The release code name, or `defaultName` when unknown.
  public static func codeNameFor(majorVersion: Int, withDefault defaultName: String) -> String {
    OSVer.macOSReleaseName(majorVersion: majorVersion) ?? defaultName
  }

  /// Returns the default display name combining the code name and version for the metadata.
  ///
  /// - Parameter metadata: The installed operating system metadata.
  /// - Returns: A name such as `macOS Sequoia 15.1`.
  public static func defaultName(fromMetadata metadata: any OperatingSystemInstalled) -> String {
    // swiftlint:disable:next line_length
    "macOS \(codeNameWithDefaultFor(majorVersion: metadata.operatingSystemVersion.majorVersion)) \(metadata.operatingSystemVersion)"
  }

  /// Returns a short operating system name for a version, optionally including the build version.
  ///
  /// - Parameters:
  ///   - osVer: The operating system version.
  ///   - buildVersion: The build version to append in brackets, if available.
  /// - Returns: A name such as `macOS 15.1 [24B83]`.
  public static func operatingSystemShortName(for osVer: OSVer, buildVersion: String?) -> String {
    let shortNameWithoutName = "\(shortName) \(osVer)"

    guard let buildVersion else {
      return shortNameWithoutName
    }

    return "\(shortNameWithoutName) [\(buildVersion)]"
  }

  /// Builds a fully populated metadata label describing the operating system.
  ///
  /// - Parameter metadata: The installed operating system metadata.
  /// - Returns: A ``MetadataLabel`` with the various display names for the operating system.
  public static func label(fromMetadata metadata: any OperatingSystemInstalled) -> MetadataLabel {
    .init(
      operatingSystemLongName: self.operatingSystemLongName(for: metadata),
      defaultName: self.defaultName(fromMetadata: metadata),
      imageName: self.imageName(for: metadata),
      systemName: self.shortName,
      versionName: MacOSVirtualization.codeNameWithDefaultFor(
        majorVersion: metadata.operatingSystemVersion.majorVersion
      ),
      shortName: self.operatingSystemShortName(
        for: metadata.operatingSystemVersion,
        buildVersion: metadata.buildVersion
      )
    )
  }
}
