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

@available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
internal final class MachineSystemTests: XCTestCase {
  // MARK: - CreateBuilder

  internal func testSuccessfulCreateBuilderForBuildConfiguration() async throws {
    let sut = MachineSystemSpy(result: .success(()))

    _ = try await sut.createBuilder(
      for: .sample,
      at: .bushelWebSite
    )

    XCTAssertTrue(sut.isCreateBuiderForConfigurationCalled)
  }

  internal func testSuccessfulCreateBuilderForSetupConfiguration() async throws {
    let sut = MachineSystemSpy(result: .success(()))

    _ = try await sut.createBuilder(
      for: MachineSetupConfiguration.sample,
      image: .sample,
      withDataDirectoryAt: .bushelWebSite
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
        for: .sample,
        at: .bushelWebSite
      )
    }
  }

  // MARK: - MachineAtURL

  internal func testSuccessfulMachineAtURL() throws {
    let sut = MachineSystemSpy(result: .success(()))

    _ = try sut.machine(
      at: .bushelWebSite,
      withConfiguration: .sample
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
        at: .bushelWebSite,
        withConfiguration: .sample
      )
    }
  }

  // MARK: - RestoreImage

  internal func testSuccessfulRestoreImage() async throws {
    let sut = MachineSystemSpy(result: .success(()))

    _ = try await sut.restoreImage(from: .sample)

    XCTAssertTrue(sut.isRestoreImageFromCalled)
  }

  internal func testFailedRestoreImage() async throws {
    let expectedError = MachineSystemError.restoreImage

    let sut = MachineSystemSpy(result: .failure(expectedError))

    await assertAsyncThrowableBlock(
      expectedError: expectedError
    ) {
      try await sut.restoreImage(from: .sample)
    }
  }
}
