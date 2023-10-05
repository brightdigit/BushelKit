//
// XCTestCase+AssertThrowableBlock.swift
// Copyright (c) 2023 BrightDigit.
//

import XCTest

public extension XCTestCase {
  func assertAsyncThrowableBlock<T: MockError>(
    expectedError: T,
    _ throwableBlock: () async throws -> Any
  ) async {
    do {
      _ = try await throwableBlock()
    } catch {
      guard
        let actualError = error as? T,
        actualError == expectedError else {
        XCTFail("Expected error of type \(expectedError)")
        return
      }
    }
  }

  func assertThrowableBlock<T: MockError>(
    expectedError: T,
    _ throwableBlock: () throws -> Any
  ) {
    let expectation = XCTestExpectation()

    XCTAssertThrowsError(try throwableBlock()) { actualError in
      guard
        let actualError = actualError as? T,
        actualError == expectedError else {
        XCTFail("Expected error of type \(expectedError)")
        expectation.fulfill()
        return
      }

      expectation.fulfill()
    }

    wait(for: [expectation], timeout: 0.100)
  }
}
