//
// MachineBuildRequestTests.swift
// Copyright (c) 2023 BrightDigit.
//

@testable import BushelCore
import XCTest

final class MachineBuildRequestTests: XCTestCase {
  func testNillMachineRestoreImageIdentifier() {
    let sut = MachineBuildRequest(restoreImage: nil)

    XCTAssertNil(sut.restoreImage)
  }

  func testNotNillMachineRestoreImageIdentifier() {
    let restoreImage = InstallerImageIdentifier.sample
    let sut = MachineBuildRequest(restoreImage: restoreImage)

    XCTAssertNotNil(sut.restoreImage)
    XCTAssertEqual(sut.restoreImage, restoreImage)
  }
}
