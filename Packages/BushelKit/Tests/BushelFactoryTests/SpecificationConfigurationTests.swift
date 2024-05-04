//
// SpecificationConfigurationTests.swift
// Copyright (c) 2024 BrightDigit.
//

import BushelFactory
import XCTest

final class SpecificationConfigurationTests: XCTestCase {
  func testTemplateUpdate() {
    var configuration = SpecificationConfiguration<UUID>()
    configuration.template = .init(
      nameID: .init(),
      systemImageName: "basic",
      idealStorage: .random(in: 100 ... 1000),
      memoryWithin: Specifications.Handlers.min,
      cpuWithin: Specifications.Handlers.min
    )
    XCTAssertNotNil(configuration.template)
    configuration.memoryIndex = 2
    XCTAssertNil(configuration.template)
  }
}
