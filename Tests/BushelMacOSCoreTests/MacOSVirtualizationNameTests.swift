//
//  MacOSVirtualizationNameTests.swift
//  BushelKit
//
//  Created by Leo Dion.
//  Copyright © 2025 BrightDigit.
//
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the "Software"), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or
//  sell copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
//

import BushelFoundation
import OSVer
import XCTest

@testable import BushelMacOSCore

internal final class MacOSVirtualizationNameTests: XCTestCase {
  // Test mock structure that implements OperatingSystemInstalled
  private struct TestOS: OperatingSystemInstalled {
    let buildVersion: String?
    let operatingSystemVersion: OSVer
  }

  // MARK: - Default Name Tests

  internal func testDefaultNameFromMetadataWithCodeName() {
    // Given
    // Use macOS 14 which should have a code name (Sonoma)
    let testOS = TestOS(
      buildVersion: "23D5026f",
      operatingSystemVersion: OSVer(major: 14, minor: 3, patch: 0)
    )

    // When
    let result = MacOSVirtualization.defaultName(fromMetadata: testOS)

    // Then
    XCTAssertTrue(result.contains("macOS"))
    XCTAssertTrue(result.contains("Sonoma"))
    XCTAssertTrue(result.contains("14.3"))
  }

  internal func testDefaultNameFromMetadataWithoutCodeName() {
    // Given
    // Use a very high macOS version which should not have a code name
    let testOS = TestOS(
      buildVersion: "ABC123",
      operatingSystemVersion: OSVer(major: 99, minor: 1, patch: 0)
    )

    // When
    let result = MacOSVirtualization.defaultName(fromMetadata: testOS)

    // Then
    XCTAssertTrue(result.contains("macOS"))
    XCTAssertTrue(result.contains("99"))
    XCTAssertTrue(result.contains("99.1"))
  }

  // MARK: - Operating System Short Name Tests

  internal func testOperatingSystemShortNameWithBuildVersion() {
    // Given
    let osVer = OSVer(major: 14, minor: 3, patch: 0)
    let buildVersion = "23D5026f"

    // When
    let result = MacOSVirtualization.operatingSystemShortName(
      for: osVer,
      buildVersion: buildVersion
    )

    // Then
    XCTAssertEqual(result, "macOS 14.3")
    XCTAssertTrue(result.contains(MacOSVirtualization.shortName))
    XCTAssertTrue(result.contains("14.3"))
    XCTAssertFalse(result.contains(buildVersion))
  }

  internal func testOperatingSystemShortNameWithoutBuildVersion() {
    // Given
    let osVer = OSVer(major: 14, minor: 3, patch: 0)

    // When
    let result = MacOSVirtualization.operatingSystemShortName(for: osVer, buildVersion: nil)

    // Then
    XCTAssertEqual(result, "macOS 14.3")
    XCTAssertTrue(result.contains(MacOSVirtualization.shortName))
    XCTAssertTrue(result.contains("14.3"))
  }

  // MARK: - Integration Test

  internal func testLabelShortNameConsistency() {
    // Given
    let testOS = TestOS(
      buildVersion: "23D5026f",
      operatingSystemVersion: OSVer(major: 14, minor: 3, patch: 0)
    )

    // When
    let label = MacOSVirtualization.label(fromMetadata: os)
    let shortName = MacOSVirtualization.operatingSystemShortName(
      for: testOS.operatingSystemVersion,
      buildVersion: testOS.buildVersion
    )

    // Then
    XCTAssertEqual(label.shortName, shortName)
  }
}
