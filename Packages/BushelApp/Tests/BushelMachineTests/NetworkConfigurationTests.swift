//
// NetworkConfigurationTests.swift
// Copyright (c) 2024 BrightDigit.
//

@testable import BushelMachine
import XCTest

internal final class NetworkConfigurationTests: XCTestCase {
  internal func testDefaultInstanceOfTypeNat() {
    let sut = NetworkConfiguration.default()

    XCTAssertEqual(sut.attachment, .nat)
  }
}
