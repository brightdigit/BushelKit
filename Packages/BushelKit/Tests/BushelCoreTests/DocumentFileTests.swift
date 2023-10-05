//
// DocumentFileTests.swift
// Copyright (c) 2023 BrightDigit.
//

@testable import BushelCore
import BushelCoreWax
import XCTest

internal final class DocumentFileTests: XCTestCase {
  internal func testDocumentFileFromInvalidFileURLType() {
    let expectedDoc = DocumentFile<TestFileTypeSpecification>.documentFile(
      from: .temporaryDir
    )

    XCTAssertNil(expectedDoc)
  }

  internal func testDocumentFileFromFileURLType() {
    let expectedDoc = DocumentFile<TestFileTypeSpecification>.documentFile(
      from: .temporaryDir.appendingPathComponent("fake.test")
    )

    XCTAssertNotNil(expectedDoc)
  }
}
