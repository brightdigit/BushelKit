//
// LibraryImageFileTests.swift
// Copyright (c) 2024 BrightDigit.
//

import BushelCore
@testable import BushelLibrary
import BushelLibraryWax
import BushelTestUtlities
import XCTest

internal final class LibraryImageFileTests: XCTestCase {
  internal func testDecoding() throws {
    let expectedImageFile = LibraryImageFile.libraryImageSample

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

    let sut = try decode(LibraryImageFile.self, from: jsonString, using: JSON.decoder)

    XCTAssertEqual(sut.id, expectedImageFile.id)
    XCTAssertEqual(sut.name, expectedImageFile.name)
    XCTAssertEqual(sut.metadata.vmSystemID, expectedImageFile.metadata.vmSystemID)
    XCTAssertEqual(sut.metadata.operatingSystemVersion, expectedImageFile.metadata.operatingSystemVersion)
    XCTAssertEqual(sut.metadata.contentLength, expectedImageFile.metadata.contentLength)
    XCTAssertEqual(sut.metadata.buildVersion, expectedImageFile.metadata.buildVersion)
    XCTAssertEqual(sut.metadata.fileExtension, expectedImageFile.metadata.fileExtension)
    XCTAssertEqual(sut.metadata.isImageSupported, expectedImageFile.metadata.isImageSupported)
  }

  internal func testEquatable() {
    let sut1 = LibraryImageFile.libraryImageSample
    let sut2 = LibraryImageFile.libraryImageSample

    XCTAssertEqual(sut1, sut2)
  }
}
