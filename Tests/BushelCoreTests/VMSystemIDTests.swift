//
//  VMSystemIDTests.swift
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

import XCTest

@testable import BushelFoundation

internal final class VMSystemIDTests: XCTestCase {
  internal func testExpressibleByStringInterpolation() {
    let sut: VMSystemID = "86F07806-1F75-4E77-AA1C-BC33DD96A9DC"

    XCTAssertEqual(sut.rawValue, "86F07806-1F75-4E77-AA1C-BC33DD96A9DC")
  }

  internal func testInit() {
    let expectedID = UUID().uuidString

    let sut = VMSystemID(stringLiteral: expectedID)

    let actualID = sut.rawValue

    XCTAssertEqual(actualID, expectedID)
  }

  internal func testEncode() throws {
    let uuidString = UUID().uuidString
    let sut = VMSystemID(stringLiteral: uuidString)

    let encodedData = try JSONEncoder().encode(sut)

    let expectedEncodedUUID = "\"\(uuidString)\""
    let actualEncodedUUID = String(data: encodedData, encoding: .utf8)

    XCTAssertEqual(actualEncodedUUID, expectedEncodedUUID)
  }

  internal func testDecode() throws {
    let uuidString = UUID().uuidString
    let json = Data("\"\(uuidString)\"".utf8)

    XCTAssertNoThrow(try JSONDecoder().decode(VMSystemID.self, from: json))
  }
}
