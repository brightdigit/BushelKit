//
//  ReleaseCollection.swift
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

public import BushelFoundation
public import BushelMachine
public import Foundation

public struct ReleaseCollection {
  private struct ReleaseVersions {
    let versionNumbers: [Int: Int]
    let releases: [ReleaseMetadata]

    private init(versionNumbers: [Int: Int], releases: [ReleaseMetadata]) {
      self.versionNumbers = versionNumbers
      self.releases = releases
    }

    fileprivate init(
      releaseCollection: any ReleaseCollectionMetadata,
      imageDictionary: ImageDictionary,
      customVersionsAllowed: Bool
    ) {
      let sortedReleases = releaseCollection.releases.sorted {
        $0.majorVersion < $1.majorVersion
      }

      assert(
        Set(sortedReleases.map(\.majorVersion)).isSuperset(of: imageDictionary.keys)
          || releaseCollection.customVersionsAllowed
      )

      assert(sortedReleases.first != nil)

      var releases = [ReleaseMetadata]()
      var versionNumbers = [Int: Int]()

      for (offset, release) in sortedReleases.enumerated() {
        let images = imageDictionary[release.majorVersion, default: []]
        releases.append(
          .init(metadata: release, images: images)
        )
        versionNumbers[release.majorVersion] = offset
      }

      if customVersionsAllowed {
        let customReleaseKeys = Set(imageDictionary.keys).subtracting(
          sortedReleases.map(\.majorVersion)
        )
        let customImages: [any InstallerImage] =
          imageDictionary.flatMap {
            (key: Int, value: [any InstallerImage]) -> [any InstallerImage] in
            guard customReleaseKeys.contains(key) else {
              return []
            }
            return value
          }
        releases.append(
          ReleaseMetadata(metadata: CustomRelease.instance, images: customImages)
        )
      }

      self.init(
        versionNumbers: versionNumbers,
        releases: releases
      )
    }
  }
  public struct Options: OptionSet, Codable, Hashable, Sendable {
    public static let noDuplicates: Self = .init(rawValue: 1)

    public var rawValue: Int

    public init(rawValue: Int) {
      self.rawValue = rawValue
    }
  }

  public let versionNumbers: [Int: Int]
  public let releases: [ReleaseMetadata]
  public let customVersionsAllowed: Bool
  public let prefix: String

  public var containsCustomVersions: Bool {
    guard self.customVersionsAllowed else {
      return false
    }
    return !customVersions.isEmpty
  }

  public var customVersions: [any InstallerImage] {
    assert(self.customVersionsAllowed)
    guard self.customVersionsAllowed else {
      return []
    }
    return releases.last?.images ?? []
  }

  private init(
    versionNumbers: [Int: Int],
    releases: [ReleaseMetadata],
    customVersionsAllowed: Bool,
    prefix: String
  ) {
    self.versionNumbers = versionNumbers
    self.releases = releases
    self.customVersionsAllowed = customVersionsAllowed
    self.prefix = prefix
  }

  public init(
    releaseCollection: any ReleaseCollectionMetadata,
    images: [any InstallerImage],
    sortOrder: SortOrder? = nil,
    options: Options = .init()
  ) {
    let imageDictionary: ImageDictionary = .init(
      images: images,
      uniqueOnly: options.contains(.noDuplicates)
    )
    .sorted(
      byOrder: sortOrder
    )

    let versions = ReleaseVersions(
      releaseCollection: releaseCollection,
      imageDictionary: imageDictionary,
      customVersionsAllowed: releaseCollection.customVersionsAllowed
    )

    self.init(
      versionNumbers: versions.versionNumbers,
      releases: versions.releases,
      customVersionsAllowed: releaseCollection.customVersionsAllowed,
      prefix: releaseCollection.prefix
    )
  }

  public func findSelection(byID identifier: InstallerImageIdentifier) -> ReleaseQueryResult? {
    for release in releases {
      if let image = release.images.first(where: { $0.identifier.imageID == identifier.imageID }) {
        return ReleaseQueryResult(
          release: .init(metadata: release),
          version: SelectedVersion(image: image)
        )
      }
    }
    return nil
  }

  public subscript(majorVersion: Int) -> ReleaseMetadata? {
    guard let index = versionNumbers[majorVersion] else {
      return nil
    }
    guard index >= 0, index < releases.count - (self.customVersionsAllowed ? 1 : 0) else {
      return nil
    }
    return self.releases[index]
  }
}

extension ReleaseCollection {
  public var isEmpty: Bool {
    self.releases.allSatisfy(\.images.isEmpty)
  }
}
