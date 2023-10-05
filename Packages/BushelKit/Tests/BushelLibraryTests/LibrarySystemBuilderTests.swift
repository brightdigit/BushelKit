//
// LibrarySystemBuilderTests.swift
// Copyright (c) 2023 BrightDigit.
//

@testable import BushelLibrary
import BushelLibraryWax
import XCTest

internal final class LibrarySystemBuilderTests: XCTestCase {
  internal func testBuildBlock() {
    let macOS = MacOSLibrarySystemStub(id: "macOS")
    let ubuntu = UbuntuLibrarySystemStub(id: "Ubuntu")

    let result: [any LibrarySystem] = LibrarySystemBuilder.buildBlock(macOS, ubuntu)

    XCTAssertEqual(result.count, 2)
    XCTAssertEqual(result[0].id, macOS.id)
    XCTAssertEqual(result[1].id, ubuntu.id)
  }
}
