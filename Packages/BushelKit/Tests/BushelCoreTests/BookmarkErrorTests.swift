//
// BookmarkErrorTests.swift
// Copyright (c) 2023 BrightDigit.
//

@testable import BushelCore
import XCTest

final class BookmarkErrorTests: XCTestCase {
  func testDatabaseError() {
    let expectedError = BushelCoreTestError.database

    let sut = BookmarkError.databaseError(expectedError)

    let actualError = sut.innerError as? BushelCoreTestError

    XCTAssertEqual(actualError, expectedError)
    XCTAssertEqual(sut.details, .database)
  }

  func testAccessDeniedError() {
    let expectedError = BushelCoreTestError.accessDenied
    let expectedURL = URL.bushelappURL

    let sut = BookmarkError.accessDeniedError(expectedError, at: expectedURL)

    let actualError = sut.innerError as? BushelCoreTestError

    XCTAssertEqual(actualError, expectedError)
    XCTAssertEqual(sut.details, .accessDeniedAt(expectedURL))
  }
}
