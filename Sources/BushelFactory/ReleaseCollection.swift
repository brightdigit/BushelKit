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

/// An ordered collection of releases and their installer images, grouped by major version.
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
  /// Options controlling how a release collection is built.
  public struct Options: OptionSet, Codable, Hashable, Sendable {
    /// Excludes duplicate images when building the collection.
    public static let noDuplicates: Self = .init(rawValue: 1)

    /// The underlying bitmask value of the option set.
    public var rawValue: Int

    /// Creates an option set from its raw bitmask value.
    /// - Parameter rawValue: The raw bitmask value.
    public init(rawValue: Int) {
      self.rawValue = rawValue
    }
  }

  /// A mapping from each major version to its index within ``releases``.
  public let versionNumbers: [Int: Int]
  /// The releases contained in this collection, ordered by major version.
  public let releases: [ReleaseMetadata]
  /// A Boolean value indicating whether custom (user-supplied) versions are permitted.
  public let customVersionsAllowed: Bool
  /// The display prefix used for releases in this collection.
  public let prefix: String

  /// A Boolean value indicating whether the collection contains any custom versions.
  public var containsCustomVersions: Bool {
    guard self.customVersionsAllowed else {
      return false
    }
    return !customVersions.isEmpty
  }

  /// The installer images belonging to the custom release, if custom versions are allowed.
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

  /// Creates a release collection by pairing release metadata with the provided installer images.
  /// - Parameters:
  ///   - releaseCollection: The metadata describing the available releases.
  ///   - images: The installer images to distribute across the releases.
  ///   - sortOrder: The order in which images within a release are sorted.
  ///   - options: Options controlling how the collection is built.
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

  /// Finds the release and image matching the given image identifier.
  /// - Parameter identifier: The identifier of the image to locate.
  /// - Returns: The matching release and version, or `nil` if no image matches.
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

  /// Returns the release metadata for the given major version, excluding the custom release.
  /// - Parameter majorVersion: The major version to look up.
  /// - Returns: The matching release metadata, or `nil` if no non-custom release exists for the version.
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
  /// A Boolean value indicating whether every release in the collection has no images.
  public var isEmpty: Bool {
    self.releases.allSatisfy(\.images.isEmpty)
  }
}
