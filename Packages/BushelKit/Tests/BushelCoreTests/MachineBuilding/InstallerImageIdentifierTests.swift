//
// InstallerImageIdentifierTests.swift
// Copyright (c) 2023 BrightDigit.
//

@testable import BushelCore
import XCTest

final class InstallerImageIdentifierTests: XCTestCase {
  func testFailedInitializeFromEmptyString() {
    let sut = InstallerImageIdentifier(string: "")

    XCTAssertNil(sut)
  }

  func testFailedInitializeFromInvalidStrings() {
    var sut = InstallerImageIdentifier(string: "2480CC13-8CFE-4CB6-9FBF-FFD2157B8995")

    XCTAssertNil(sut)

    sut = InstallerImageIdentifier(string: ":2480CC13-8CFE-4CB6-9FBF-FFD2157B8995")

    XCTAssertNil(sut)
  }

  func testSuccessfulInitFromValidStringIdentifier() {
    let expectedIdentifier = String.restoreImageIdentiferSample

    guard let sut = InstallerImageIdentifier(string: expectedIdentifier) else {
      return XCTFail("Expected initlization of MachineRestoreImageIdentifier from string identifier: \(expectedIdentifier)")
    }

    let actualIdentifier = sut.description

    XCTAssertEqual(actualIdentifier, expectedIdentifier)
  }

  func testInitializeFromLibraryIDAndImageID() {
    let expectedLibraryID = LibraryIdentifier.sampleBookmarkID
    let expectedImageID = UUID.sampleImageID

    let sut = InstallerImageIdentifier(libraryID: expectedLibraryID, imageID: expectedImageID)

    XCTAssertEqual(sut.libraryID, expectedLibraryID)
    XCTAssertEqual(sut.imageID, expectedImageID)
  }

  func testEncodeIntoJsonString() throws {
    let restoreImageIdentifier = String.restoreImageIdentiferSample

    guard let sut = InstallerImageIdentifier(string: restoreImageIdentifier) else {
      return XCTFail("Expected initlization of MachineRestoreImageIdentifier from string identifier: \(restoreImageIdentifier)")
    }

    let encodedData = try JSONEncoder().encode(sut)

    let expectedEncodedIdentifier = "\"\(restoreImageIdentifier)\""
    let actualEncodedIdentifier = String(data: encodedData, encoding: .utf8)

    XCTAssertEqual(expectedEncodedIdentifier, actualEncodedIdentifier)
  }

  func testDecodeFromJsonString() throws {
    let restoreImageIdentifier = String.restoreImageIdentiferSample
    let sut = "\"\(restoreImageIdentifier)\"".data(using: .utf8)!

    XCTAssertNoThrow(try JSONDecoder().decode(InstallerImageIdentifier.self, from: sut))
  }
}
