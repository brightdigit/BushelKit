//
//  MachineSystemTests.swift
//  BushelKit
//
//  Created by Leo Dion.
//  Copyright © 2024 BrightDigit.
//
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the “Software”), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or
//  sell copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
//

import BushelMachineWax
import XCTest

@testable import BushelMachine

internal final class MachineSystemTests: XCTestCase {
  // MARK: - CreateBuilder

  func testSuccessfulCreateBuilderForBuildConfiguration() async throws {
    let sut = MachineSystemSpy(result: .success(()))

    _ = try await sut.createBuilder(
      for: .sampleMachineBuildConfiguration,
      at: .bushelWebSite
    )

    XCTAssertTrue(sut.isCreateBuiderForConfigurationCalled)
  }

  func testSuccessfulCreateBuilderForSetupConfiguration() async throws {
    let sut = MachineSystemSpy(result: .success(()))

    _ = try await sut.createBuilder(
      for: .sampleMachineSetupConfiguration,
      image: .sampleInstallerImage,
      withDataDirectoryAt: .bushelWebSite
    )

    XCTAssertTrue(sut.isCreateBuiderForConfigurationCalled)
  }

  func testFailedCreateBuilderForConfiguration() async throws {
    let expectedError = MachineSystemError.createBuilderForConfiguration

    let sut = MachineSystemSpy(result: .failure(expectedError))

    await assertAsyncThrowableBlock(
      expectedError: expectedError
    ) {
      try await sut.createBuilder(
        for: .sampleMachineBuildConfiguration,
        at: .bushelWebSite
      )
    }
  }

  // MARK: - MachineAtURL

  func testSuccessfulMachineAtURL() throws {
    let sut = MachineSystemSpy(result: .success(()))

    _ = try sut.machine(
      at: .bushelWebSite,
      withConfiguration: .sampleMachineConfiguration
    )

    XCTAssertTrue(sut.isMachineAtURLCalled)
  }

  func testFailedMachineAtURL() async throws {
    let expectedError = MachineSystemError.machineAtURL

    let sut = MachineSystemSpy(result: .failure(expectedError))

    assertThrowableBlock(
      expectedError: expectedError
    ) {
      try sut.machine(
        at: .bushelWebSite,
        withConfiguration: .sampleMachineConfiguration
      )
    }
  }

  // MARK: - RestoreImage

  func testSuccessfulRestoreImage() async throws {
    let sut = MachineSystemSpy(result: .success(()))

    _ = try await sut.restoreImage(from: .sampleInstallerImage)

    XCTAssertTrue(sut.isRestoreImageFromCalled)
  }

  func testFailedRestoreImage() async throws {
    let expectedError = MachineSystemError.restoreImage

    let sut = MachineSystemSpy(result: .failure(expectedError))

    await assertAsyncThrowableBlock(
      expectedError: expectedError
    ) {
      try await sut.restoreImage(from: .sampleInstallerImage)
    }
  }
}
