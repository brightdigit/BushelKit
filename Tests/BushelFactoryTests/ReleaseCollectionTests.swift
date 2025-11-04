//
//  ReleaseCollectionTests.swift
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

import BushelFactory
import BushelFoundation
import BushelFoundationWax
import BushelMachine
import Foundation
import OSVer
import Testing

@Suite("Release Collection Tests")
internal struct ReleaseCollectionTests {
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

  private func assertThat(
    actualRelease: ReleaseMetadata,
    equalsExpectedRelease release: any InstallerRelease,
    fromDictionary imageSample: [Int: [MockInstallerImage]]
  ) {
    let actualImages = actualRelease.images.compactMap { image in
      image as? MockInstallerImage
    }
    #expect(actualRelease.id.hashValue == release.id.hashValue)
    #expect(!actualRelease.isCustom)
    #expect(actualImages == imageSample[release.majorVersion])
    #expect(actualRelease.metadata.majorVersion == release.majorVersion)
    #expect(actualRelease.metadata.imageName == release.imageName)
    #expect(actualRelease.metadata.releaseName == release.releaseName)
    #expect(actualRelease.metadata.versionName == release.versionName)
  }

  private func customVersions(
    whenAllowed expectedCustomVersionsAllowed: Bool,
    fromCollection actualReleaseCollection: ReleaseCollection
  ) -> [MockInstallerImage] {
    guard expectedCustomVersionsAllowed else {
      return []
    }
    return actualReleaseCollection.customVersions
      .compactMap { image in
        image as? MockInstallerImage
      }
      .sorted {
        $0.imageID.uuidString < $1.imageID.uuidString
      }
  }

  // swiftlint:disable:next function_body_length
  private func doTestReleaseCollectionWhere(
    customVersionsAllowed expectedCustomVersionsAllowed: Bool,
    withCustomReleaseCount customReleaseCount: Int? = nil
  ) {
    let parameters = TestParameters.random(
      expectedCustomVersionsAllowed: expectedCustomVersionsAllowed,
      releaseCount: customReleaseCount
    )

    let releaseCollection = MockReleaseCollectionMetadata.random(
      startingAt: parameters.expectedFirstMajorVersion,
      count: parameters.releaseCount,
      customVersionsAllowed: expectedCustomVersionsAllowed
    )
    let imageDictionary = MockInstallerImage.random(
      withReleaseCount: parameters.releaseCount,
      startingAt: parameters.expectedFirstMajorVersion,
      withAverageImageCount: parameters.averageImageCountPerRelease,
      includingCustomReleaseCount: parameters.customReleaseCount
    )

    let expectedCustomVersions =
      imageDictionary
      .filter { (key: Int, _: [MockInstallerImage]) in
        !parameters.indexRange.contains(key)
      }
      .flatMap(\.value)
      .sorted {
        $0.imageID.uuidString < $1.imageID.uuidString
      }

    let actualReleaseCollection = ReleaseCollection(
      releaseCollection: releaseCollection,
      images: imageDictionary.values.flatMap { $0 }
    )
    let actualCustomVersions = customVersions(
      whenAllowed: expectedCustomVersionsAllowed,
      fromCollection: actualReleaseCollection
    )

    #expect(actualReleaseCollection.containsCustomVersions == (parameters.customReleaseCount > 0))
    #expect(actualReleaseCollection.customVersionsAllowed == expectedCustomVersionsAllowed)
    #expect(
      actualReleaseCollection.customVersionsAllowed == releaseCollection.customVersionsAllowed)
    #expect(actualReleaseCollection.prefix == releaseCollection.prefix)
    #expect(actualCustomVersions == expectedCustomVersions)

    let sortedReleases = releaseCollection.releases.sorted(
      by: { $0.majorVersion < $1.majorVersion }
    )
    for expectedRelease in sortedReleases {
      guard let actualRelease = actualReleaseCollection[expectedRelease.majorVersion] else {
        #expect(actualReleaseCollection[expectedRelease.majorVersion] != nil)
        continue
      }

      assertThat(
        actualRelease: actualRelease,
        equalsExpectedRelease: expectedRelease,
        fromDictionary: imageDictionary
      )
    }
  }

  @Test("Initialize Release Collection")
  internal func testInit() {
    let testCount: Int = .random(in: 10...20)
    for _ in 0..<testCount {
      doTestReleaseCollectionWhere(
        customVersionsAllowed: false
      )
    }
    for _ in 0..<testCount {
      doTestReleaseCollectionWhere(
        customVersionsAllowed: true
      )
    }
  }
}
