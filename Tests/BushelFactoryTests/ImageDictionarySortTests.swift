//
//  ImageDictionarySortTests.swift
//  BushelKit
//
//  Created by Leo Dion.
//  Copyright © 2025 BrightDigit.
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

@Suite("Image Dictionary Sort Tests")
internal struct ImageDictionarySortTests {
  private struct TestInstallerImage: InstallerImage {
    let operatingSystemVersion: OSVer
    let libraryID: LibraryIdentifier? = nil
    let imageID = UUID()
    let metadata: InstallerImage.Metadata

    init(operatingSystemVersion: OSVer) {
      self.operatingSystemVersion = operatingSystemVersion
      self.metadata = .init(
        longName: "Test Image",
        defaultName: "Test",
        labelName: "Test",
        operatingSystem: operatingSystemVersion,
        buildVersion: nil,
        imageResourceName: "test",
        systemName: "Test",
        systemID: "test"
      )
    }

    func getURL() async throws -> URL {
      // swiftlint:disable:next force_unwrapping
      URL(string: "file:///test")!
    }
  }

  @Test("Sort ImageDictionary with Forward Order")
  internal func testSortWithForwardOrder() {
    // Given
    let majorVersion = 14
    let image1 = TestInstallerImage(
      operatingSystemVersion: OSVer(majorVersion: majorVersion, minorVersion: 3, patchVersion: 0)
    )
    let image2 = TestInstallerImage(
      operatingSystemVersion: OSVer(majorVersion: majorVersion, minorVersion: 1, patchVersion: 0)
    )
    let image3 = TestInstallerImage(
      operatingSystemVersion: OSVer(majorVersion: majorVersion, minorVersion: 2, patchVersion: 0)
    )

    let dictionary: [Int: [TestInstallerImage]] = [
      majorVersion: [image1, image2, image3]
    ]

    // When
    let sortedDictionary = dictionary.mapValues { images in
      images.sorted { $0.operatingSystemVersion < $1.operatingSystemVersion }
    }

    // Then
    #expect(sortedDictionary.count == 1)
    #expect(sortedDictionary[majorVersion]?.count == 3)

    let sortedImages = sortedDictionary[majorVersion] ?? []
    #expect(sortedImages.count == 3)

    // Verify images are sorted in ascending order
    for index in 0..<sortedImages.count - 1 {
      #expect(
        sortedImages[index].operatingSystemVersion < sortedImages[index + 1].operatingSystemVersion)
    }
  }

  @Test("Sort ImageDictionary with Reverse Order")
  internal func testSortWithReverseOrder() {
    // Given
    let majorVersion = 14
    let image1 = TestInstallerImage(
      operatingSystemVersion: OSVer(majorVersion: majorVersion, minorVersion: 3, patchVersion: 0)
    )
    let image2 = TestInstallerImage(
      operatingSystemVersion: OSVer(majorVersion: majorVersion, minorVersion: 1, patchVersion: 0)
    )
    let image3 = TestInstallerImage(
      operatingSystemVersion: OSVer(majorVersion: majorVersion, minorVersion: 2, patchVersion: 0)
    )

    let dictionary: [Int: [TestInstallerImage]] = [
      majorVersion: [image1, image2, image3]
    ]

    // When
    let sortedDictionary = dictionary.mapValues { images in
      images.sorted { $0.operatingSystemVersion > $1.operatingSystemVersion }
    }

    // Then
    #expect(sortedDictionary.count == 1)
    #expect(sortedDictionary[majorVersion]?.count == 3)

    let sortedImages = sortedDictionary[majorVersion] ?? []
    #expect(sortedImages.count == 3)

    // Verify images are sorted in descending order
    for index in 0..<sortedImages.count - 1 {
      #expect(
        sortedImages[index].operatingSystemVersion > sortedImages[index + 1].operatingSystemVersion)
    }
  }

  @Test("Sort ImageDictionary with Nil Order")
  internal func testSortWithNilOrder() {
    // Given
    let dictionary: [Int: [TestInstallerImage]] = [14: []]

    // When
    let sortedDictionary = dictionary

    // Then
    #expect(sortedDictionary.count == dictionary.count)
    #expect(sortedDictionary[14]?.count == dictionary[14]?.count)
  }
}
