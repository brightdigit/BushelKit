//
// MachineSetupRequestConfigurationTests.swift
// Copyright (c) 2024 BrightDigit.
//

import BushelCore
import BushelCoreWax
@testable import BushelMachine
import BushelMachineWax
import XCTest

internal final class MachineSetupRequestConfigurationTests: XCTestCase {
  internal func testNilMachineBuildRequest() {
    let sut = MachineSetupConfiguration(request: nil)

    XCTAssertNil(sut.libraryID)
    XCTAssertNil(sut.restoreImageID)
  }

  internal func testActualMachineBuildRequest() {
    let request = MachineBuildRequest(restoreImage: .sampleInstallerIdentifier)
    let sut = MachineSetupConfiguration(request: request)

    XCTAssertEqual(sut.libraryID, request.restoreImage?.libraryID)
    XCTAssertEqual(sut.restoreImageID, request.restoreImage?.imageID)
  }
}
