//
//  ReleaseCollection.swift
//  Sublimation
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
public import BushelMachine

public struct ReleaseCollection {
  public let firstMajorVersion: Int
  public let releases: [ReleaseMetadata]
  public let customVersionsAllowed: Bool
  public let prefix: String

  public var containsCustomVersions: Bool {
    guard customVersionsAllowed else { return false }
    return !customVersions.isEmpty
  }

  public var customVersions: [any InstallerImage] {
    assert(customVersionsAllowed)
    guard customVersionsAllowed else { return [] }
    return releases.last?.images ?? []
  }

  private init(
    firstMajorVersion: Int,
    releases: [ReleaseMetadata],
    prefix: String,
    customVersionsAllowed: Bool
  ) {
    self.prefix = prefix
    self.customVersionsAllowed = customVersionsAllowed
    self.firstMajorVersion = firstMajorVersion
    self.releases = releases
  }

  public init(releaseCollection: any ReleaseCollectionMetadata, images: [any InstallerImage]) {
    let imageDictionary = Dictionary(grouping: images) { image in
      image.operatingSystemVersion.majorVersion
    }
    let sourceReleases = releaseCollection.releases.sorted { $0.majorVersion < $1.majorVersion }
    var releases = [ReleaseMetadata]()

    assert(
      Set(sourceReleases.map(\.majorVersion)).isSuperset(of: imageDictionary.keys)
        || releaseCollection.customVersionsAllowed
    )

    assert(sourceReleases.first != nil)

    let firstMajorVersion = sourceReleases.first?.majorVersion ?? 0
    var lastMajorVersion: Int = .max
    for release in sourceReleases {
      let images = imageDictionary[release.majorVersion, default: []]
      releases.append(.init(metadata: release, images: images))
      assert(
        lastMajorVersion == .max && firstMajorVersion == release.majorVersion
          || lastMajorVersion + 1 == release.majorVersion
      )
      lastMajorVersion = release.majorVersion
    }
    if releaseCollection.customVersionsAllowed {
      let customReleaseKeys = Set(imageDictionary.keys)
        .subtracting(sourceReleases.map(\.majorVersion))
      let customImages: [any InstallerImage] = imageDictionary.flatMap {
        (key: Int, value: [any InstallerImage]) -> [any InstallerImage] in
        guard customReleaseKeys.contains(key) else { return [] }
        return value
      }
      releases.append(ReleaseMetadata(metadata: CustomRelease.instance, images: customImages))
    }
    self.init(
      firstMajorVersion: firstMajorVersion,
      releases: releases,
      prefix: releaseCollection.prefix,
      customVersionsAllowed: releaseCollection.customVersionsAllowed
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
    let index = majorVersion - firstMajorVersion
    guard index >= 0, index < releases.count - (customVersionsAllowed ? 1 : 0) else { return nil }
    return releases[index]
  }
}

extension ReleaseCollection { public var isEmpty: Bool { releases.allSatisfy(\.images.isEmpty) } }
