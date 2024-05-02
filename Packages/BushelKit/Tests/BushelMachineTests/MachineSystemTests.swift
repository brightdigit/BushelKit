//
// MachineSystemTests.swift
// Copyright (c) 2024 BrightDigit.
//

@testable import BushelMachine
import BushelMachineWax
import XCTest

internal final class MachineSystemTests: XCTestCase {
  // MARK: - CreateBuilder

  internal func testSuccessfulCreateBuilderForBuildConfiguration() async throws {
    let sut = MachineSystemSpy(result: .success(()))

    _ = try await sut.createBuilder(
      for: .sampleMachineBuildConfiguration,
      at: .bushelappURL
    )

    XCTAssertTrue(sut.isCreateBuiderForConfigurationCalled)
  }

  internal func testSuccessfulCreateBuilderForSetupConfiguration() async throws {
    let sut = MachineSystemSpy(result: .success(()))

    _ = try await sut.createBuilder(
      for: .sampleMachineSetupConfiguration,
      image: .sampleInstallerImage,
      withDataDirectoryAt: .bushelappURL
    )

    XCTAssertTrue(sut.isCreateBuiderForConfigurationCalled)
  }

  internal func testFailedCreateBuilderForConfiguration() async throws {
    let expectedError = MachineSystemError.createBuilderForConfiguration

    let sut = MachineSystemSpy(result: .failure(expectedError))

    await assertAsyncThrowableBlock(
      expectedError: expectedError
    ) {
      try await sut.createBuilder(
        for: .sampleMachineBuildConfiguration,
        at: .bushelappURL
      )
    }
  }

  // MARK: - MachineAtURL

  internal func testSuccessfulMachineAtURL() throws {
    let sut = MachineSystemSpy(result: .success(()))

    _ = try sut.machine(
      at: .bushelappURL,
      withConfiguration: .sampleMachineConfiguration
    )

    XCTAssertTrue(sut.isMachineAtURLCalled)
  }

  internal func testFailedMachineAtURL() async throws {
    let expectedError = MachineSystemError.machineAtURL

    let sut = MachineSystemSpy(result: .failure(expectedError))

    assertThrowableBlock(
      expectedError: expectedError
    ) {
      try sut.machine(
        at: .bushelappURL,
        withConfiguration: .sampleMachineConfiguration
      )
    }
  }

  // MARK: - RestoreImage

  internal func testSuccessfulRestoreImage() async throws {
    let sut = MachineSystemSpy(result: .success(()))

    _ = try await sut.restoreImage(from: .sampleInstallerImage)

    XCTAssertTrue(sut.isRestoreImageFromCalled)
  }

  internal func testFailedRestoreImage() async throws {
    let expectedError = MachineSystemError.restoreImage

    let sut = MachineSystemSpy(result: .failure(expectedError))

    await assertAsyncThrowableBlock(
      expectedError: expectedError
    ) {
      try await sut.restoreImage(from: .sampleInstallerImage)
    }
  }
}
