//
// SpecificationConfigurationTests.swift
// Copyright (c) 2024 BrightDigit.
//

import BushelFactory
import XCTest

internal final class SpecificationConfigurationTests: XCTestCase {
  func testTemplateUpdate() {
    var configuration = SpecificationConfiguration()
    configuration.template = .basic
    XCTAssertNotNil(configuration.template)
    configuration.memoryIndex = 2
    XCTAssertNil(configuration.template)
  }
}
