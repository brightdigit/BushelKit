//
// VirtualizationDataTests.swift
// Copyright (c) 2024 BrightDigit.
//

@testable import BushelCore
import BushelCoreWax
import XCTest

final class VirtualizationDataTests: XCTestCase {
  private func randomVirtualizationDataTest() throws {
    let expectedMachineIdentifier =
      MachineIdentifier(ecID: .random(in: 1_755_652_291_379_785_502 ... UInt64.max))
    let expectedHardwareModel =
      HardwareModel(dataRepresentationVersion: 1, minimumSupportedOS: .random(), platformVersion: 2)

    let dataSet = try MockDataSet(
      machineIdentifier: expectedMachineIdentifier,
      hardwareModel: expectedHardwareModel
    )

    let virtualizationData = try VirtualizationData(at: dataSet, using: .init())

    XCTAssertEqual(virtualizationData.hardwareModel, expectedHardwareModel)
    XCTAssertEqual(virtualizationData.machineIdentifier, expectedMachineIdentifier)
  }

  internal func testSuccessfulParsing() throws {
    let count = Int.random(in: 5 ... 10)
    for _ in 0 ..< count {
      try randomVirtualizationDataTest()
    }
  }
}
