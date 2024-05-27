//
// MachineBuildRequestTests.swift
// Copyright (c) 2024 BrightDigit.
//

@testable import BushelCore
import XCTest

internal final class MachineBuildRequestTests: XCTestCase {
  func testNillMachineRestoreImageIdentifier() {
    let sut = MachineBuildRequest(restoreImage: nil)

    XCTAssertNil(sut.restoreImage)
  }

  func testNotNillMachineRestoreImageIdentifier() {
    let restoreImage = InstallerImageIdentifier.sampleInstallerIdentifier
    let sut = MachineBuildRequest(restoreImage: restoreImage)

    XCTAssertNotNil(sut.restoreImage)
    XCTAssertEqual(sut.restoreImage, restoreImage)
  }
}
