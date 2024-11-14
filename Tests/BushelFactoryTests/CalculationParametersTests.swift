//
//  CalculationParametersTests.swift
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

@testable import BushelFactory

internal final class CalculationParametersTests: XCTestCase {
  internal func testIndexForValue() {
    let exp = expectation(description: "Called Closure")
    let expectedValue: Int = .random(in: 1...100)
    let expectedPassingValue: Int = .random(in: 1...100)
    let specCalcParameters = SpecificationCalculationParameters(
      indexRange: 1...50,
      valueRange: 100...1_000
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

  internal func testValueUsing() {
    let exp = expectation(description: "Called Closure")
    let expectedValue: Int = .random(in: 1...100)
    let expectedPassingValue: Int = .random(in: 1...100)
    let specCalcParameters = SpecificationCalculationParameters(
      indexRange: 1...50,
      valueRange: 100...1_000
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

  internal func testFloats() {
    let specCalcParameters = SpecificationCalculationParameters(
      indexRange: 0.1...50.1,
      valueRange: 99.1...1_000.1
    ) { passedValue in
      XCTFail("Shouldn't be called")
      return passedValue
    }

    XCTAssertEqual(specCalcParameters.indexRange.lowerBound, 1)
    XCTAssertEqual(specCalcParameters.indexRange.upperBound, 50)
    XCTAssertEqual(specCalcParameters.valueRange.lowerBound, 100)
    XCTAssertEqual(specCalcParameters.valueRange.upperBound, 1_000)
  }

  internal func testValue() {
    let indexRange: ClosedRange<Int> = .random(startingIn: 0...100, withSizeWithin: 10...20)

    let valueRange: ClosedRange<Int> = .random(startingIn: 0...100, withSizeWithin: 10...20)
    let parameters = MockCalculationParameters(
      expectedIndex: .random(in: 0...100),
      indexRange: indexRange,
      valueRange: valueRange
    )
    let expectation = expectation(description: "Called closure.")
    let expectedValue: Int = .random(in: 100...200)
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
