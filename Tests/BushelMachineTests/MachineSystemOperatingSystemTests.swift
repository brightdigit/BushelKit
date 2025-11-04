//
//  MachineSystemOperatingSystemTests.swift
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

import OSVer
import XCTest

@testable import BushelMachine
@testable import BushelMachineWax

@available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
internal final class MachineSystemOperatingSystemTests: XCTestCase {
  internal func testMachineSystemStubOperatingSystemShortName() {
    // Given
    let sut = MachineSystemStub(id: "test")
    let osVer = OSVer(majorVersion: 14, minorVersion: 3, patchVersion: 0)
    let buildVersion = "23D5026f"

    // When
    let result = sut.operatingSystemShortName(for: osVer, buildVersion: buildVersion)

    // Then
    XCTAssertTrue(result.contains("14.3"))
    XCTAssertTrue(result.contains(buildVersion))
  }

  internal func testMachineSystemSpyOperatingSystemShortName() {
    // Given
    let sut = MachineSystemSpy(result: .success(()))
    let osVer = OSVer(majorVersion: 14, minorVersion: 3, patchVersion: 0)
    let buildVersion = "23D5026f"

    // When
    let result = sut.operatingSystemShortName(for: osVer, buildVersion: buildVersion)

    // Then
    XCTAssertTrue(result.contains("14.3"))
    XCTAssertTrue(result.contains(buildVersion))
    XCTAssertEqual(result, "\(osVer.description) \(buildVersion)")
  }

  internal func testMachineSystemStubOperatingSystemShortNameWithoutBuildVersion() {
    // Given
    let sut = MachineSystemStub(id: "test")
    let osVer = OSVer(majorVersion: 14, minorVersion: 3, patchVersion: 0)
    let buildVersion: String? = nil

    // When
    let result = sut.operatingSystemShortName(for: osVer, buildVersion: buildVersion)

    // Then
    XCTAssertTrue(result.contains("14.3"))
    XCTAssertFalse(result.contains("nil"))
    XCTAssertEqual(result, osVer.description)
  }

  internal func testMachineSystemSpyOperatingSystemShortNameWithoutBuildVersion() {
    // Given
    let sut = MachineSystemSpy(result: .success(()))
    let osVer = OSVer(majorVersion: 14, minorVersion: 3, patchVersion: 0)
    let buildVersion: String? = nil

    // When
    let result = sut.operatingSystemShortName(for: osVer, buildVersion: buildVersion)

    // Then
    XCTAssertTrue(result.contains("14.3"))
    XCTAssertEqual(result, osVer.description)
  }

  internal func testOperatingSystemShortNameWithPatchVersion() {
    // Given
    let sut = MachineSystemStub(id: "test")
    let osVer = OSVer(majorVersion: 14, minorVersion: 3, patchVersion: 2)
    let buildVersion = "23D5026f"

    // When
    let result = sut.operatingSystemShortName(for: osVer, buildVersion: buildVersion)

    // Then
    XCTAssertTrue(result.contains("14.3.2"))
    XCTAssertTrue(result.contains(buildVersion))
  }
}
