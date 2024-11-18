//
//  FileManagerTests.swift
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

import BushelFoundationWax
import XCTest

@testable import BushelFoundation

internal final class FileManagerTests: XCTestCase {
  // Skipped, because cannot be tested.
  //  func testSuccessfulCreateFile() throws {
  //    let sut = FileManager.default
  //
  //    let dirURL = URL.temporaryDirectory
  //    let fileURL = dirURL.appendingPathComponent("file.txt")
  //
  //    try sut.createFile(atPath: fileURL.absoluteString, withSize: 1000)
  //  }

  internal func testDirectoryExists() {
    let sut = FileManager.default

    let dirURL = URL.temporaryDir

    XCTAssertEqual(sut.directoryExists(at: dirURL), .directoryExists)
  }

  internal func testNotExists() {
    let sut = FileManager.default

    let fileURL = URL.temporaryDir.appendingPathComponent("file.txt")

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
