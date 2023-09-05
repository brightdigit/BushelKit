//
// OperatingSystemVersionTests.swift
// Copyright (c) 2023 BrightDigit.
//

@testable import BushelCore
import XCTest

final class OperatingSystemVersionTests: XCTestCase {
  func testEquality() throws {
    let version1 = "13.5.1"
    let version2 = "13.5.1"
    let version3 = "10.8.2"

    let sut1 = try OperatingSystemVersion(string: version1)
    let sut2 = try OperatingSystemVersion(string: version2)
    let sut3 = try OperatingSystemVersion(string: version3)

    XCTAssertEqual(sut1, sut2)
    XCTAssertNotEqual(sut1, sut3)
  }

  func testSuccessfulInitFromThreePartsVersionString() throws {
    let version = "13.5.1"

    let sut = try OperatingSystemVersion(string: version)

    XCTAssertEqual(sut.description, version)
  }

  func testSuccessfulInitFromTwoPartsVersionString() throws {
    let version = "13.5"

    let sut = try OperatingSystemVersion(string: version)

    XCTAssertEqual(sut.description, version + ".0")
  }

  func testFailedInitFromVersionString() throws {
    let version = "13.5.1.1005"

    XCTAssertThrowsError(try OperatingSystemVersion(string: version)) { actualError in
      let actualError = actualError as? OperatingSystemVersion.Error

      XCTAssertNotNil(actualError)
      XCTAssertEqual(actualError, .invalidFormatString(version))
    }
  }

  func testDecodeFromVersionString() throws {
    let version = "13.5.1"

    let data = "\"\(version)\"".data(using: .utf8)!

    let sut = try JSONDecoder().decode(OperatingSystemVersion.self, from: data)

    XCTAssertEqual(sut.description, version)
  }

  func testDecodeFromKeyedVersionString() throws {
    let version = "13.5.1"
    let verList = version.split(separator: ".").compactMap { Int($0) }
    let majorVersion = verList[0]
    let minorVersion = verList[1]
    let patchVersion = verList[2]

    let data = """
    {
      "majorVersion": \(majorVersion),
      "minorVersion": \(minorVersion),
      "patchVersion": \(patchVersion)
    }
    """.data(using: .utf8)!

    let sut = try JSONDecoder().decode(OperatingSystemVersion.self, from: data)

    XCTAssertEqual(sut.majorVersion, majorVersion)
    XCTAssertEqual(sut.minorVersion, minorVersion)
    XCTAssertEqual(sut.patchVersion, patchVersion)
    XCTAssertEqual(sut.description, version)
  }
}
