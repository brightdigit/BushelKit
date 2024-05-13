//
// LibrarySystemManagerTests.swift
// Copyright (c) 2024 BrightDigit.
//

import BushelCoreWax
@testable import BushelLibrary
import BushelLibraryWax
import XCTest

internal final class LibrarySystemManagerTests: XCTestCase {
  internal func testResolveSystemBasedOnID() {
    let macOSSystem = MacOSLibrarySystemStub(id: "macOS")
    let ubuntuSystem = UbuntuLibrarySystemStub(id: "ubuntu")

    let sut = LibrarySystemManager(
      [macOSSystem, ubuntuSystem],
      fileTypeBasedOnURL: { _ in nil }
    )

    XCTAssertEqual(sut.resolve(macOSSystem.id).id, macOSSystem.id)
  }

  internal func test() async throws {
    let macOSSystem = MacOSLibrarySystemStub(id: "macOS")
    let ubuntuSystem = UbuntuLibrarySystemStub(id: "ubuntu")

    let sut = LibrarySystemManager(
      [macOSSystem, ubuntuSystem],
      fileTypeBasedOnURL: { _ in nil }
    )

    try await assertLabel(byManager: sut, forSystem: macOSSystem)
    try await assertLabel(byManager: sut, forSystem: ubuntuSystem)
  }

  private func assertLabel(
    byManager manager: any LibrarySystemManaging,
    forSystem system: any LibrarySystem
  ) async throws {
    let metadata = try await system.metadata(fromURL: .temporaryDir)

    XCTAssertEqual(
      manager.labelForSystem(system.id, metadata: metadata),
      system.label(fromMetadata: metadata)
    )
  }
}
