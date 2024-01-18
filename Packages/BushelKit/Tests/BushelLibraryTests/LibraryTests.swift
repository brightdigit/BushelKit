//
// LibraryTests.swift
// Copyright (c) 2024 BrightDigit.
//

@testable import BushelLibrary
import XCTest

internal final class LibraryTests: XCTestCase {
  internal func testCorrectInitialization() {
    let items: [LibraryImageFile] = [
      .monterey_12_6_0,
      .sonoma_13_6_0
    ]

    let sut = Library(items: items)

    XCTAssertEqual(sut.items, items)
  }
}
