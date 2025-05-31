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

public enum MacOSVirtualization: Sendable {
  public static let allowedContentTypes: Set<FileType> = Set(FileType.ipswTypes)

  public static let shortName = "macOS"

  public static var ipswFileExtension: String {
    FileType.ipswFileExtension
  }

  public static func operatingSystemLongName(for metadata: any OperatingSystemInstalled) -> String {
    let shortName = defaultName(fromMetadata: metadata)
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
    OSVer.macOSReleaseName(majorVersion: majorVersion)
  }

  public static func codeNameWithDefaultFor(majorVersion: Int) -> String {
    self.codeNameFor(majorVersion: majorVersion, withDefault: majorVersion.description)
  }

  public static func codeNameFor(majorVersion: Int, withDefault defaultName: String) -> String {
    OSVer.macOSReleaseName(majorVersion: majorVersion) ?? defaultName
  }

  public static func defaultName(fromMetadata metadata: any OperatingSystemInstalled) -> String {
    // swiftlint:disable:next line_length
    "macOS \(codeNameWithDefaultFor(majorVersion: metadata.operatingSystemVersion.majorVersion)) \(metadata.operatingSystemVersion)"
  }

  public static func operatingSystemShortName(for osVer: OSVer, buildVersion: String?) -> String {
    let shortNameWithoutName = "\(shortName) \(osVer)"

    guard let buildVersion else {
      return shortNameWithoutName
    }

    return "\(shortNameWithoutName) [\(buildVersion)]"
  }

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
