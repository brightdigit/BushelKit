//
// TransformationTests.swift
// Copyright (c) 2024 BrightDigit.
//

@testable import BushelCore
import XCTest

final class TransformationTests: XCTestCase {
  func testTransformAsFunction() {
    let sut = Transformation<Int, String>(intToString)

    let value = 3
    let expectedValue = intToString(value)
    let actualValue = sut(value)

    XCTAssertEqual(actualValue, expectedValue)
  }

  private func intToString(_ value: Int) -> String {
    "\(value)"
  }
}
