//
// MachineConfigurationUpdatingTests.swift
// Copyright (c) 2023 BrightDigit.
//

import BushelCore
@testable import BushelMachine
import XCTest

internal final class MachineConfigurationUpdatingTests: XCTestCase {
  internal func testUpdatingUsingBuildRequest() {
    var sut = MachineSetupConfiguration(request: .sampleBuildRequest)

    let request = MachineBuildRequest(
      restoreImage: .init(
        imageID: UUID(),
        libraryID: LibraryIdentifier(string: UUID().uuidString)
      )
    )

    sut.updating(forRequest: request)

    XCTAssertEqual(sut.libraryID, request.restoreImage?.libraryID)
    XCTAssertEqual(sut.restoreImageID, request.restoreImage?.imageID)
  }
}
