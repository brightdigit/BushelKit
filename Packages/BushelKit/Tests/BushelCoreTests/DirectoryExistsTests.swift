//
// DirectoryExistsTests.swift
// Copyright (c) 2024 BrightDigit.
//

@testable import BushelCore
import XCTest

final class DirectoryExistsTests: XCTestCase {
  func testFileExists() {
    let sut = DirectoryExists(fileExists: true, isDirectory: false)

    XCTAssertEqual(sut, .fileExists)
  }

  func testDirectoryExists() {
    let sut = DirectoryExists(fileExists: true, isDirectory: true)

    XCTAssertEqual(sut, .directoryExists)
  }

  func testNotExists() {
    let sut = DirectoryExists(fileExists: false, isDirectory: false)

    XCTAssertEqual(sut, .notExists)
  }
}
