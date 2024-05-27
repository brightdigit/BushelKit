//
// CalculationParametersTests.swift
// Copyright (c) 2024 BrightDigit.
//

import BushelCoreWax
@testable import BushelFactory
import XCTest

internal final class CalculationParametersTests: XCTestCase {
  func testIndexForValue() {
    let exp = expectation(description: "Called Closure")
    let expectedValue: Int = .random(in: 1 ... 100)
    let expectedPassingValue: Int = .random(in: 1 ... 100)
    let specCalcParameters = SpecificationCalculationParameters(
      indexRange: 1 ... 50,
      valueRange: 100 ... 1_000
    ) { passedValue in
      defer {
        exp.fulfill()
      }
      XCTAssertEqual(passedValue, expectedPassingValue)
      return expectedValue
    }
    let actualValue = specCalcParameters.indexFor(value: expectedPassingValue)
    XCTAssertEqual(actualValue, expectedValue)
    wait(for: [exp], timeout: 5.0)
  }

  func testValueUsing() {
    let exp = expectation(description: "Called Closure")
    let expectedValue: Int = .random(in: 1 ... 100)
    let expectedPassingValue: Int = .random(in: 1 ... 100)
    let specCalcParameters = SpecificationCalculationParameters(
      indexRange: 1 ... 50,
      valueRange: 100 ... 1_000
    ) { passedValue in
      XCTFail("Shouldn't be called")
      return passedValue
    }
    let actualValue = specCalcParameters.value { _, _ in
      defer {
        exp.fulfill()
      }
      return expectedValue
    }
    XCTAssertEqual(actualValue, expectedValue)
    wait(for: [exp], timeout: 5.0)
  }

  func testFloats() {
    let specCalcParameters = SpecificationCalculationParameters(
      indexRange: 0.1 ... 50.1,
      valueRange: 99.1 ... 1_000.1
    ) { passedValue in
      XCTFail("Shouldn't be called")
      return passedValue
    }

    XCTAssertEqual(specCalcParameters.indexRange.lowerBound, 1)
    XCTAssertEqual(specCalcParameters.indexRange.upperBound, 50)
    XCTAssertEqual(specCalcParameters.valueRange.lowerBound, 100)
    XCTAssertEqual(specCalcParameters.valueRange.upperBound, 1_000)
  }

  func testValue() {
    let indexRange: ClosedRange<Int> = .random(startingIn: 0 ... 100, withSizeWithin: 10 ... 20)

    let valueRange: ClosedRange<Int> = .random(startingIn: 0 ... 100, withSizeWithin: 10 ... 20)
    let parameters = MockCalculationParameters(
      expectedIndex: .random(in: 0 ... 100),
      indexRange: indexRange,
      valueRange: valueRange
    )
    let expectation = expectation(description: "Called closure.")
    let expectedValue: Int = .random(in: 100 ... 200)
    let actualValue = parameters.value {
      defer {
        expectation.fulfill()
      }
      XCTAssertEqual($0, indexRange.lowerBound)
      XCTAssertEqual($1, indexRange.upperBound)
      return expectedValue
    }
    wait(for: [expectation], timeout: 5.0)
    XCTAssertEqual(actualValue, expectedValue)
  }
}
