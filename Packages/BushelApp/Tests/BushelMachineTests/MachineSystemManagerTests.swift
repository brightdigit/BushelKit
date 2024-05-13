//
// MachineSystemManagerTests.swift
// Copyright (c) 2024 BrightDigit.
//

@testable import BushelMachine
import BushelMachineWax
import XCTest

internal final class MachineSystemManagerTests: XCTestCase {
  internal func testResolveById() {
    let stubOS1: MachineSystemStub = .stubOS1
    let stubOS2: MachineSystemStub = .stubOS2
    let stubOS3: MachineSystemStub = .stubOS3

    let sut = MachineSystemManager([stubOS1, stubOS2, stubOS3])

    let stubOS1Impl = sut.resolve(stubOS1.id) as? MachineSystemStub
    let stubOS2Impl = sut.resolve(stubOS2.id) as? MachineSystemStub

    XCTAssertEqual(stubOS1Impl, stubOS1)
    XCTAssertEqual(stubOS2Impl, stubOS2)
  }
}
