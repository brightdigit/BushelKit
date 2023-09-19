//
// MachineSetupRequestConfigurationTests.swift
// Copyright (c) 2023 BrightDigit.
//

import BushelCore
@testable import BushelMachine
import BushelTestsCore
import XCTest

internal final class MachineSetupRequestConfigurationTests: XCTestCase {
  internal func testNilMachineBuildRequest() {
    let sut = MachineSetupConfiguration(request: nil)

    XCTAssertNil(sut.libraryID)
    XCTAssertNil(sut.restoreImageID)
  }

  internal func testActualMachineBuildRequest() {
    let request = MachineBuildRequest(restoreImage: .sample)
    let sut = MachineSetupConfiguration(request: request)

    XCTAssertEqual(sut.libraryID, request.restoreImage?.libraryID)
    XCTAssertEqual(sut.restoreImageID, request.restoreImage?.imageID)
  }
}
