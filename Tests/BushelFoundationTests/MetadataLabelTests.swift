//
//  MetadataLabelTests.swift
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

import XCTest

@testable import BushelFoundation

internal final class MetadataLabelTests: XCTestCase {
  internal func testInitializer() {
    // Given
    let operatingSystemLongName = "macOS Sonoma 14.3 (23D5026f)"
    let defaultName = "macOS Sonoma 14.3"
    let imageName = "OSVersions/Sonoma"
    let systemName = "macOS"
    let versionName = "Sonoma"
    let shortName = "macOS 14.3"

    // When
    let sut = MetadataLabel(
      operatingSystemLongName: operatingSystemLongName,
      defaultName: defaultName,
      imageName: imageName,
      systemName: systemName,
      versionName: versionName,
      shortName: shortName
    )

    // Then
    XCTAssertEqual(sut.operatingSystemLongName, operatingSystemLongName)
    XCTAssertEqual(sut.defaultName, defaultName)
    XCTAssertEqual(sut.imageName, imageName)
    XCTAssertEqual(sut.systemName, systemName)
    XCTAssertEqual(sut.versionName, versionName)
    XCTAssertEqual(sut.shortName, shortName)
  }
}
