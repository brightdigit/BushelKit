//
// URLWaxTests.swift
// Copyright (c) 2024 BrightDigit.
//

@testable import BushelCore
import XCTest

final class URLWaxTests: XCTestCase {
  func testRandomHTTP() {
    let sut = URL.randomHTTP()

    XCTAssertTrue(URL.urlsString.contains(sut.absoluteString))
  }

  func testRandomFile() {
    let sut = URL.randomFile()

    XCTAssertTrue(sut.isFileURL)
  }
}
