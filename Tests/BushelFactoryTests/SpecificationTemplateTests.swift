//
//  SpecificationTemplateTests.swift
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

@testable import BushelFactory

internal final class SpecificationTemplateTests: XCTestCase {
  internal func testIndex() {
    let expectedCPUIndex: Int = .random(in: 10...100)
    let expectedMemoryIndex: Int = .random(in: 10...100)
    let template = SpecificationTemplate<UUID>(
      nameID: .init(),
      systemImageName: .randomLowerCaseAlphaNumberic(),
      idealStorage: .random(in: 10...1_000)
    ) { _ in
      expectedMemoryIndex
    } cpuWithin: { _ in
      expectedCPUIndex
    }
    let actualCPUIndex = template.cpuWithin(
      MockCalculationParameters(expectedIndex: 15, indexRange: 0...12, valueRange: 0...100)
    )

    let actualMemoryIndex = template.memoryWithin(
      MockCalculationParameters(expectedIndex: 15, indexRange: 0...12, valueRange: 0...100)
    )
    XCTAssertEqual(actualCPUIndex, expectedCPUIndex)
    XCTAssertEqual(actualMemoryIndex, expectedMemoryIndex)
  }
}
