//
// SpecificationTemplateTests.swift
// Copyright (c) 2024 BrightDigit.
//

@testable import BushelFactory
import XCTest

final class SpecificationTemplateTests: XCTestCase {
  func testIndex() {
    let expectedCPUIndex: Int = .random(in: 10 ... 100)
    let expectedMemoryIndex: Int = .random(in: 10 ... 100)
    let template = SpecificationTemplate<UUID>(
      nameID: .init(),
      systemImageName: .randomLowerCaseAlphaNumberic(),
      idealStorage: .random(in: 10 ... 1000)
    ) { _ in
      expectedMemoryIndex
    } cpuWithin: { _ in
      expectedCPUIndex
    }
    let actualCPUIndex = template.cpuWithin(
      MockCalculationParameters(expectedIndex: 15, indexRange: 0 ... 12, valueRange: 0 ... 100)
    )

    let actualMemoryIndex = template.memoryWithin(
      MockCalculationParameters(expectedIndex: 15, indexRange: 0 ... 12, valueRange: 0 ... 100)
    )
    XCTAssertEqual(actualCPUIndex, expectedCPUIndex)
    XCTAssertEqual(actualMemoryIndex, expectedMemoryIndex)
  }
}
