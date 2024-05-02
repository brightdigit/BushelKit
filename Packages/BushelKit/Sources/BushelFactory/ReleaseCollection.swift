//
// ReleaseCollection.swift
// Copyright (c) 2024 BrightDigit.
//

import BushelCore
import BushelMachine

public struct ReleaseCollection {
  public let firstMajorVersion: Int
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
    let sourceReleases = releaseCollection.releases.sorted {
      $0.majorVersion < $1.majorVersion
    }
    var releases = [ReleaseMetadata]()

    assert(
      Set(sourceReleases.map(\.majorVersion)).isSuperset(of: imageDictionary.keys) ||
        releaseCollection.customVersionsAllowed
    )

    assert(sourceReleases.first != nil)

    let firstMajorVersion = sourceReleases.first?.majorVersion ?? 0
    var lastMajorVersion: Int = .max
    for release in sourceReleases {
      let images = imageDictionary[release.majorVersion, default: []]
      releases.append(
        .init(metadata: release, images: images)
      )
      assert(
        lastMajorVersion == .max && firstMajorVersion == release.majorVersion
          || lastMajorVersion + 1 == release.majorVersion
      )
      lastMajorVersion = release.majorVersion
    }
    if releaseCollection.customVersionsAllowed {
      let customReleaseKeys = Set(imageDictionary.keys).subtracting(sourceReleases.map(\.majorVersion))
      let customImages: [any InstallerImage] =
        imageDictionary.flatMap { (key: Int, value: [any InstallerImage]) -> [any InstallerImage] in
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
      firstMajorVersion: firstMajorVersion,
      releases: releases,
      prefix: releaseCollection.prefix,
      customVersionsAllowed: releaseCollection.customVersionsAllowed
    )
  }

  public func findSelection(byID identifier: InstallerImageIdentifier) -> ReleaseQueryResult? {
    for release in releases {
      if let image = release.images.first(where: { $0.identifier.imageID == identifier.imageID }) {
        return ReleaseQueryResult(release: .init(metadata: release), version: SelectedVersion(image: image))
      }
    }
    return nil
  }

  public subscript(majorVersion: Int) -> ReleaseMetadata? {
    let index = majorVersion - firstMajorVersion
    guard index >= 0, index < releases.count - (self.customVersionsAllowed ? 1 : 0) else {
      return nil
    }
    return self.releases[index]
  }
}
