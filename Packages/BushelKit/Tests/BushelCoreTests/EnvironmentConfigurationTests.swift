//
// EnvironmentConfigurationTests.swift
// Copyright (c) 2023 BrightDigit.
//

@testable import BushelCore
import XCTest

final class EnvironmentConfigurationTests: XCTestCase {
  func testEnableAssertionFailureForError() {
    let env = [
      "DISABLE_ASSERTION_FAILURE_FOR_ERROR": "false"
    ]

    let sut = EnvironmentConfiguration(environment: env)

    XCTAssertFalse(sut.disableAssertionFailureForError)
  }
}
