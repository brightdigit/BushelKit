//
// LibraryIdentifierTests.swift
// Copyright (c) 2023 BrightDigit.
//

@testable import BushelCore
import Foundation
import XCTest

final class LibraryIdentifierTests: XCTestCase {
  func testBookmarkIDFromString() {
    let expectedID = LibraryIdentifier.bookmarkID(.bookmarkIDSample)

    let sut = LibraryIdentifier(string: .libraryBookmarkIDSample)

    XCTAssertEqual(sut.description, expectedID.description)
  }

  func testURLFromString() {
    let fileURL = URL.homeDirectory.appendingPathComponent("file.txt")
    let url = LibraryIdentifier.url(fileURL)

    let sut = LibraryIdentifier(string: fileURL.path)

    XCTAssertEqual(sut.description, url.description)
  }
}
