//
//  ReleaseCollectionAdvancedTests.swift
//  BushelKit
//
//  Created by Leo Dion.
//  Copyright © 2024 BrightDigit.
//
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the "Software"), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or
//  sell copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
//

import BushelFactory
import BushelFoundation
import BushelFoundationWax
import BushelMachine
import Foundation
import OSVer
import Testing

@Suite("Release Collection Advanced Tests")
internal struct ReleaseCollectionAdvancedTests {
  private struct TestParameters {
    let customReleaseCount: Int
    let expectedFirstMajorVersion: Int
    let releaseCount: Int
    let averageImageCountPerRelease: Int

    var indexRange: Range<Int> {
      self.expectedFirstMajorVersion..<(self.expectedFirstMajorVersion + self.releaseCount)
    }

    private init(
      customReleaseCount: Int,
      expectedFirstMajorVersion: Int,
      releaseCount: Int,
      averageImageCountPerRelease: Int
    ) {
      self.customReleaseCount = customReleaseCount
      self.expectedFirstMajorVersion = expectedFirstMajorVersion
      self.releaseCount = releaseCount
      self.averageImageCountPerRelease = averageImageCountPerRelease
    }

    static func random(
      expectedCustomVersionsAllowed: Bool,
      expectedFirstMajorVersion: Int? = nil,
      releaseCount: Int? = nil,
      averageImageCountPerRelease: Int? = nil
    ) -> TestParameters {
      self.init(
        customReleaseCount: expectedCustomVersionsAllowed ? .random(in: 0...2) : 0,
        expectedFirstMajorVersion: expectedFirstMajorVersion ?? .random(in: 4...30),
        releaseCount: releaseCount ?? .random(in: 3...10),
        averageImageCountPerRelease: averageImageCountPerRelease ?? .random(in: 3...6)
      )
    }
  }

  @Test("Initialize Release Collection with No Duplicates")
  internal func testInitWithNoDuplicates() {
    let parameters = TestParameters.random(
      expectedCustomVersionsAllowed: false,
      releaseCount: 3,
      averageImageCountPerRelease: 2
    )

    let releaseCollection = MockReleaseCollectionMetadata.random(
      startingAt: parameters.expectedFirstMajorVersion,
      count: parameters.releaseCount,
      customVersionsAllowed: false
    )

    // Create a dictionary with duplicate images
    var imageDictionary = MockInstallerImage.random(
      withReleaseCount: parameters.releaseCount,
      startingAt: parameters.expectedFirstMajorVersion,
      withAverageImageCount: parameters.averageImageCountPerRelease,
      includingCustomReleaseCount: 0
    )

    // Add duplicates to each release
    for (majorVersion, images) in imageDictionary {
      let duplicates = images.map { image in
        MockInstallerImage(
          libraryID: image.libraryID,
          imageID: UUID(),  // New UUID to make it a different instance
          metadata: image.metadata
        )
      }
      imageDictionary[majorVersion]?.append(contentsOf: duplicates)
    }

    // Create collection with noDuplicates option
    let actualReleaseCollection = ReleaseCollection(
      releaseCollection: releaseCollection,
      images: imageDictionary.values.flatMap { $0 },
      options: .noDuplicates
    )

    // Verify that duplicates were removed
    for (majorVersion, expectedImages) in imageDictionary {
      guard let actualRelease = actualReleaseCollection[majorVersion] else {
        #expect(actualReleaseCollection[majorVersion] != nil)
        continue
      }

      let actualImages = actualRelease.images.compactMap { $0 as? MockInstallerImage }
      // Verify that the number of images is half of the original (duplicates removed)
      #expect(actualImages.count == expectedImages.count / 2)

      // Verify that all images have unique build identifiers
      let buildIdentifiers = Set(actualImages.map { $0.buildIdentifier })
      #expect(buildIdentifiers.count == actualImages.count)
    }
  }

  @Test("Initialize Release Collection with Sort Order")
  internal func testInitWithSortOrder() {
    // Create a release collection with specific images to test sorting
    let releaseCollection = MockReleaseCollectionMetadata.random(
      startingAt: 10,
      count: 3,
      customVersionsAllowed: false
    )

    // Create images with different versions for testing sorting
    let majorVersion = 10
    let image1 = MockInstallerImage(
      libraryID: .bookmarkID(UUID()),
      imageID: UUID(),
      metadata: .init(
        operatingSystem: OSVer(majorVersion: majorVersion, minorVersion: 1, patchVersion: 0)
      )
    )
    let image2 = MockInstallerImage(
      libraryID: .bookmarkID(UUID()),
      imageID: UUID(),
      metadata: .init(
        operatingSystem: OSVer(majorVersion: majorVersion, minorVersion: 2, patchVersion: 0)
      )
    )
    let image3 = MockInstallerImage(
      libraryID: .bookmarkID(UUID()),
      imageID: UUID(),
      metadata: .init(
        operatingSystem: OSVer(majorVersion: majorVersion, minorVersion: 3, patchVersion: 0)
      )
    )

    // Test forward sorting
    let forwardSorted = ReleaseCollection(
      releaseCollection: releaseCollection,
      images: [image3, image1, image2],
      sortOrder: .forward
    )

    // Test reverse sorting
    let reverseSorted = ReleaseCollection(
      releaseCollection: releaseCollection,
      images: [image1, image2, image3],
      sortOrder: .reverse
    )

    #expect(forwardSorted.versionNumbers.keys.count == releaseCollection.releases.count)
    #expect(reverseSorted.versionNumbers.keys.count == releaseCollection.releases.count)
  }
}
