//
// DocumentFileTests.swift
// Copyright (c) 2023 BrightDigit.
//

@testable import BushelCore
import BushelTestsCore
import XCTest

internal final class DocumentFileTests: XCTestCase {
  internal func testDocumentFileFromInvalidFileURLType() {
    let expectedDoc = DocumentFile<TestFileTypeSpecification>.documentFile(
      from: .temporaryDirectory
    )

    XCTAssertNil(expectedDoc)
  }

  internal func testDocumentFileFromFileURLType() {
    let expectedDoc = DocumentFile<TestFileTypeSpecification>.documentFile(
      from: .temporaryDirectory.appendingPathComponent("fake.test")
    )

    XCTAssertNotNil(expectedDoc)
  }
}
