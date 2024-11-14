//
//  LibraryImageFileTests.swift
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

import BushelFoundation
import BushelLibraryWax
import BushelTestUtilities
import BushelUtilities
import XCTest

@testable import BushelLibrary

internal final class LibraryImageFileTests: XCTestCase {
  internal func testDecoding() throws {
    #if canImport(FoundationNetworking)
      throw XCTSkip("Unable to import `OperatingSystemVersion` Codable in test target.")
    #else
      let expectedImageFile = LibraryImageFile.libraryImageSample

      // swiftlint:disable line_length
      let jsonString = """
        {
          "id" : "\(expectedImageFile.id.uuidString)",
          "name" : "\(expectedImageFile.name)",
          "metadata" : {
            "vmSystemID" : "\(expectedImageFile.metadata.vmSystemID.rawValue)",
            "operatingSystemVersion" : "\(expectedImageFile.metadata.operatingSystemVersion.description)",
            "contentLength" : \(expectedImageFile.metadata.contentLength),
            "isImageSupported" : \(expectedImageFile.metadata.isImageSupported),
            "lastModified" : "\(ISO8601DateFormatter().string(from: expectedImageFile.metadata.lastModified))",
            "buildVersion" : "\(expectedImageFile.metadata.buildVersion ?? "")",
            "fileExtension" : "\(expectedImageFile.metadata.fileExtension)"
          }
        }
        """
      // swiftlint:enable line_length
      let sut = try decode(LibraryImageFile.self, from: jsonString, using: JSON.decoder)

      XCTAssertEqual(sut.id, expectedImageFile.id)
      XCTAssertEqual(sut.name, expectedImageFile.name)
      XCTAssertEqual(sut.metadata.vmSystemID, expectedImageFile.metadata.vmSystemID)
      XCTAssertEqual(
        sut.metadata.operatingSystemVersion,
        expectedImageFile.metadata.operatingSystemVersion
      )
      XCTAssertEqual(sut.metadata.contentLength, expectedImageFile.metadata.contentLength)
      XCTAssertEqual(sut.metadata.buildVersion, expectedImageFile.metadata.buildVersion)
      XCTAssertEqual(sut.metadata.fileExtension, expectedImageFile.metadata.fileExtension)
      XCTAssertEqual(sut.metadata.isImageSupported, expectedImageFile.metadata.isImageSupported)
    #endif
  }

  internal func testEquatable() {
    let sut1 = LibraryImageFile.libraryImageSample
    let sut2 = LibraryImageFile.libraryImageSample

    XCTAssertEqual(sut1, sut2)
  }
}
