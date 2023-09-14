//
// ByteCountFormatterTests.swift
// Copyright (c) 2023 BrightDigit.
//

@testable import BushelCore
import XCTest

internal final class ByteCountFormatterTests: XCTestCase {
  internal func testCountStyleInit() {
    let sut = ByteCountFormatter(countStyle: .binary)

    XCTAssertEqual(sut.countStyle, .binary)
  }
}
