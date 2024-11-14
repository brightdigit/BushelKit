//
//  InstallerImageIdentifierTests.swift
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

import XCTest

@testable import BushelFoundation

internal final class InstallerImageIdentifierTests: XCTestCase {
  internal func testFailedInitializeFromEmptyString() {
    let sut = InstallerImageIdentifier(string: "")

    XCTAssertNil(sut)
  }

  internal func testFailedInitializeFromInvalidStrings() {
    var sut = InstallerImageIdentifier(string: "2480CC13-8CFE-4CB6-9FBF-FFD2157B8995")

    XCTAssertNil(sut)

    sut = InstallerImageIdentifier(string: ":2480CC13-8CFE-4CB6-9FBF-FFD2157B8995")

    XCTAssertNil(sut)
  }

  internal func testSuccessfulInitFromValidStringIdentifier() {
    let expectedIdentifier = String.restoreImageIdentiferSample

    guard let sut = InstallerImageIdentifier(string: expectedIdentifier) else {
      return XCTFail("Expected initlization from string identifier: \(expectedIdentifier)")
    }

    let actualIdentifier = sut.description

    XCTAssertEqual(actualIdentifier, expectedIdentifier)
  }

  internal func testInitializeFromLibraryIDAndImageID() {
    let expectedLibraryID = LibraryIdentifier.sampleLibraryID
    let expectedImageID = UUID.imageIDSample

    let sut = InstallerImageIdentifier(imageID: expectedImageID, libraryID: expectedLibraryID)

    XCTAssertEqual(sut.libraryID, expectedLibraryID)
    XCTAssertEqual(sut.imageID, expectedImageID)
  }

  internal func testEncodeIntoJsonString() throws {
    let restoreImageIdentifier = String.restoreImageIdentiferSample

    guard let sut = InstallerImageIdentifier(string: restoreImageIdentifier) else {
      return XCTFail("Expected initlization from string identifier: \(restoreImageIdentifier)")
    }

    let encodedData = try JSONEncoder().encode(sut)

    let expectedEncodedIdentifier = "\"\(restoreImageIdentifier)\""
    let actualEncodedIdentifier = String(data: encodedData, encoding: .utf8)

    XCTAssertEqual(expectedEncodedIdentifier, actualEncodedIdentifier)
  }

  internal func testDecodeFromJsonString() throws {
    let restoreImageIdentifier = String.restoreImageIdentiferSample

    let sut = Data("\"\(restoreImageIdentifier)\"".utf8)

    XCTAssertNoThrow(try JSONDecoder().decode(InstallerImageIdentifier.self, from: sut))
  }
}
