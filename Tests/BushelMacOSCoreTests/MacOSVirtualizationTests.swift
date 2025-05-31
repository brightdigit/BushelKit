//
//  MacOSVirtualizationTests.swift
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

// Mock implementation of OperatingSystemInstalled for testing
private struct MockOperatingSystem: OperatingSystemInstalled {
  let buildVersion: String?
  let operatingSystemVersion: OSVer

  static func create(major: Int, minor: Int = 0, patch: Int = 0, buildVersion: String? = nil)
    -> MockOperatingSystem
  {
    MockOperatingSystem(
      buildVersion: buildVersion,
      operatingSystemVersion: OSVer(major: major, minor: minor, patch: patch)
    )
  }
}

internal final class MacOSVirtualizationTests: XCTestCase {
  internal func testOperatingSystemLongName() {
    // Given
    let mockOS = MockOperatingSystem.create(major: 14, minor: 3, buildVersion: "23D5026f")

    // When
    let result = MacOSVirtualization.operatingSystemLongName(for: mockOS)

    // Then
    XCTAssertTrue(result.contains("14.3"))
    XCTAssertTrue(result.contains("23D5026f"))
  }

  internal func testOperatingSystemLongNameWithoutBuildVersion() {
    // Given
    let mockOS = MockOperatingSystem.create(major: 14, minor: 3)

    // When
    let result = MacOSVirtualization.operatingSystemLongName(for: mockOS)

    // Then
    XCTAssertTrue(result.contains("14.3"))
    XCTAssertFalse(result.contains("("))
  }

  internal func testDefaultNameFromMetadata() {
    // Given
    let mockOS = MockOperatingSystem.create(major: 14, minor: 3)

    // When
    let result = MacOSVirtualization.defaultName(fromMetadata: mockOS)

    // Then
    XCTAssertTrue(result.contains("macOS"))
    XCTAssertTrue(result.contains("14.3"))
  }

  internal func testLabelFromMetadata() {
    // Given
    let mockOS = MockOperatingSystem.create(major: 14, minor: 3, buildVersion: "23D5026f")

    // When
    let label = MacOSVirtualization.label(fromMetadata: mockOS)

    // Then
    XCTAssertNotNil(label.shortName)
    XCTAssertTrue(label.shortName.contains(MacOSVirtualization.shortName))
    XCTAssertTrue(label.shortName.contains("14.3"))
  }

  internal func testOperatingSystemShortNameWithBuildVersion() {
    // Given
    let osVer = OSVer(majorVersion: 14, minorVersion: 1, patchVersion: 2)
    let buildVersion = "23B92"

    // When
    let shortName = MacOSVirtualization.operatingSystemShortName(
      for: osVer,
      buildVersion: buildVersion
    )

    // Then
    XCTAssertTrue(shortName.contains("\(osVer)"))
    XCTAssertTrue(shortName.contains("[\(buildVersion)]"))
  }

  internal func testOperatingSystemShortNameWithoutBuildVersion() {
    // Given
    let osVer = OSVer(majorVersion: 14, minorVersion: 1, patchVersion: 2)

    // When
    let shortName = MacOSVirtualization.operatingSystemShortName(for: osVer, buildVersion: nil)

    // Then
    XCTAssertEqual(shortName, "\(MacOSVirtualization.shortName) \(osVer)")
  }
}
