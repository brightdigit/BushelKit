//
//  LibrarySystemManagerTests.swift
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

import BushelFoundationWax
import BushelLibraryWax
import XCTest

@testable import BushelLibrary

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
    let verifier = MockSigVerifier(id: .macOS, verification: .signed)
    let metadata = try await system.metadata(fromURL: .temporaryDir, verifier: verifier)

    XCTAssertEqual(
      manager.labelForSystem(system.id, metadata: metadata),
      system.label(fromMetadata: metadata)
    )
  }
}
