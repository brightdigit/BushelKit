//
// AssertionFailureTests.swift
// Copyright (c) 2023 BrightDigit.
//

@testable import BushelCore
import XCTest

internal final class AssertionFailureTests: XCTestCase {
  private typealias ResultType = Result<Bool, BushelCoreTestLocalizedError>

  internal func testSuccessResult() throws {
    let expectedResult: ResultType = .success(true)

    let actualResult: ResultType = try BushelCore.assertionFailure(
      result: expectedResult
    )

    XCTAssertEqual(actualResult, expectedResult)
  }

  internal func testLocalizedErrorResult() throws {
    let expectedResult: ResultType = .failure(.sample)

    let actualResult: ResultType = try BushelCore.assertionFailure(
      result: expectedResult
    )

    XCTAssertEqual(actualResult, expectedResult)
  }
}
