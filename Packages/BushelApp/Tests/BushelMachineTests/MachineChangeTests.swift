//
// MachineChangeTests.swift
// Copyright (c) 2024 BrightDigit.
//

@testable import BushelMachine
import XCTest

internal final class MachineChangeTests: XCTestCase {
  internal func testValidMachineProperty() {
    let sut = MachineChange.PropertyChange(keyPath: MachineChange.Property.state.rawValue)

    XCTAssertNotNil(sut)
  }

  internal func testInvalidMachineProperty() {
    let sut = MachineChange.PropertyChange(keyPath: "blahblah")

    XCTAssertNil(sut)
  }
}
