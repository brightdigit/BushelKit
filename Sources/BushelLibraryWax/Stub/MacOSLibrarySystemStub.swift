//
//  MacOSLibrarySystemStub.swift
//  BushelKit
//
//  Created by Leo Dion.
//  Copyright © 2024 BrightDigit.
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

public import BushelCore
public import BushelLibrary
public import Foundation
public import RadiantDocs

public struct MacOSLibrarySystemStub: LibrarySystem {
  private static let codeNames: [Int: String] = [
    11: "Big Sur", 12: "Monterey", 13: "Ventura", 14: "Sonoma",
  ]

  public var id: VMSystemID
  public var shortName: String = "macOS"
  public var allowedContentTypes: Set<FileType> = .init()
  public var releaseCollectionMetadata: any BushelCore.ReleaseCollectionMetadata {
    fatalError("Not Implemented")
  }

  public init(id: VMSystemID) { self.id = id }

  public func metadata(fromURL _: URL) async throws -> ImageMetadata { .macOS_12_6_0_21G115 }

  public func label(fromMetadata metadata: any OperatingSystemInstalled) -> MetadataLabel {
    .init(
      operatingSystemLongName: operatingSystemLongName(forOSMetadata: metadata),
      defaultName: defaultName(fromOSMetadata: metadata),
      imageName: imageName(forOSMetadata: metadata),
      systemName: "macOS",
      versionName: codeNameFor(operatingSystemVersion: metadata.operatingSystemVersion)
    )
  }

  // MARK: - Helpers

  private func operatingSystemLongName(forOSMetadata metadata: any OperatingSystemInstalled)
    -> String
  {
    let shortName = defaultName(fromOSMetadata: metadata)
    guard let buildVersion = metadata.buildVersion else { return shortName }
    return shortName.appending(" (\(buildVersion))")
  }

  private func defaultName(fromOSMetadata metadata: any OperatingSystemInstalled) -> String {
    // swiftlint:disable:next line_length
    "macOS \(codeNameFor(operatingSystemVersion: metadata.operatingSystemVersion)) \(metadata.operatingSystemVersion)"
  }

  private func codeNameFor(operatingSystemVersion: OperatingSystemVersion) -> String {
    Self.codeNames[operatingSystemVersion.majorVersion]
      ?? operatingSystemVersion.majorVersion.description
  }

  private func imageName(forOSMetadata metadata: any OperatingSystemInstalled) -> String {
    "OSVersions/".appending(codeNameFor(operatingSystemVersion: metadata.operatingSystemVersion))
  }
}
