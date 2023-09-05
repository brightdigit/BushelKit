//
// FileManagerTests.swift
// Copyright (c) 2023 BrightDigit.
//

@testable import BushelCore
import XCTest

final class FileManagerTests: XCTestCase {
  // Skipped, because cannot be tested.
//  func testSuccessfulCreateFile() throws {
//    let sut = FileManager.default
//
//    let dirURL = URL.temporaryDirectory
//    let fileURL = dirURL.appendingPathComponent("file.txt")
//
//    try sut.createFile(atPath: fileURL.absoluteString, withSize: 1000)
//  }

  func testDirectoryExists() {
    let sut = FileManager.default

    let dirURL = URL.temporaryDirectory

    XCTAssertEqual(sut.directoryExists(at: dirURL), .directoryExists)
  }

  func testNotExists() {
    let sut = FileManager.default

    let fileURL = URL.temporaryDirectory.appendingPathComponent("file.txt")

    XCTAssertEqual(sut.directoryExists(at: fileURL), .notExists)
  }

//  // Skipped, because cannot be tested.
//  func testFileExists() {
//    let sut = FileManager.default
//
//    let fileURL = URL.temporaryDirectory.appendingPathComponent("file.txt")
//
//    sut.createFile(atPath: fileURL.absoluteString, contents: nil, attributes: nil)
//
//    XCTAssertEqual(sut.directoryExists(at: fileURL), .fileExists)
//  }
}
