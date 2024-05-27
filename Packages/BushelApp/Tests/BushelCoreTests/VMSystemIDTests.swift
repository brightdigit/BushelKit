//
// VMSystemIDTests.swift
// Copyright (c) 2024 BrightDigit.
//

@testable import BushelCore
import XCTest

internal final class VMSystemIDTests: XCTestCase {
  func testExpressibleByStringInterpolation() {
    let sut: VMSystemID = "86F07806-1F75-4E77-AA1C-BC33DD96A9DC"

    XCTAssertEqual(sut.rawValue, "86F07806-1F75-4E77-AA1C-BC33DD96A9DC")
  }

  func testInit() {
    let expectedID = UUID().uuidString

    let sut = VMSystemID(stringLiteral: expectedID)

    let actualID = sut.rawValue

    XCTAssertEqual(actualID, expectedID)
  }

  func testEncode() throws {
    let uuidString = UUID().uuidString
    let sut = VMSystemID(stringLiteral: uuidString)

    let encodedData = try JSONEncoder().encode(sut)

    let expectedEncodedUUID = "\"\(uuidString)\""
    let actualEncodedUUID = String(data: encodedData, encoding: .utf8)

    XCTAssertEqual(actualEncodedUUID, expectedEncodedUUID)
  }

  func testDecode() throws {
    let uuidString = UUID().uuidString
    // swiftlint:disable:next force_unwrapping
    let json = "\"\(uuidString)\"".data(using: .utf8)!

    XCTAssertNoThrow(try JSONDecoder().decode(VMSystemID.self, from: json))
  }
}
