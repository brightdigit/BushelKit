//
// MachinePrimaryStorageConfigurationTests.swift
// Copyright (c) 2024 BrightDigit.
//

@testable import BushelMachine
import XCTest

internal final class MachinePrimaryStorageConfigurationTests: XCTestCase {
  internal func testEmptyStorageConfiguration() {
    let sut = MachineSetupConfiguration(storage: [])

    assertPrimaryStorage(sut: sut, against: .defaultPrimary)
  }

  internal func testDefaultPrimaryStorage() {
    let sut = MachineSetupConfiguration()

    assertPrimaryStorage(sut: sut, against: .defaultPrimary)
  }

  internal func testCustomPrimaryStorage() {
    var sut = MachineSetupConfiguration()

    let expectedPrimaryStorage = MachineStorageSpecification(
      label: "test",
      size: .makeGigaByte(1)
    )

    sut.primaryStorage = expectedPrimaryStorage

    assertPrimaryStorage(sut: sut, against: expectedPrimaryStorage)
  }

  // MARK: - Helpers

  private func assertPrimaryStorage(
    sut: MachineSetupConfiguration,
    against actualStorage: MachineStorageSpecification
  ) {
    XCTAssertEqual(sut.primaryStorage, actualStorage)
  }
}
