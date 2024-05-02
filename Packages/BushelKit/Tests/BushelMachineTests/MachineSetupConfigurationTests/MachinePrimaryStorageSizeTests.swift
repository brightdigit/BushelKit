//
// MachinePrimaryStorageSizeTests.swift
// Copyright (c) 2024 BrightDigit.
//

@testable import BushelMachine
import XCTest

internal final class MachinePrimaryStorageSizeTests: XCTestCase {
  internal func testCorrectDefaultPrimaryStorageSize() {
    let sut = MachineSetupConfiguration()

    assertPrimaryStorageSizeFloat(
      sut: sut,
      against: MachineStorageSpecification.defaultSize
    )
  }

  internal func testDefaultPrimaryStorageSize() {
    var sut = MachineSetupConfiguration()

    let expectedSize = UInt64.makeGigaByte(1)

    sut.primaryStorageSizeFloat = Float(expectedSize)

    assertPrimaryStorageSizeFloat(sut: sut, against: expectedSize)
  }

  // MARK: - Helpers

  private func assertPrimaryStorageSizeFloat(
    sut: MachineSetupConfiguration,
    against actualSize: UInt64
  ) {
    XCTAssertEqual(sut.primaryStorageSizeFloat, Float(actualSize))
  }
}
