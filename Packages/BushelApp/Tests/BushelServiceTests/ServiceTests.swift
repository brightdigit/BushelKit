//
// ServiceTests.swift
// Copyright (c) 2024 BrightDigit.
//

@testable import BushelService
import XCTest

internal final class ServiceTests: XCTestCase {
  func testService() async throws {
    #if canImport(SwiftData) && !os(iOS)
      let database = MockDatabase()
      let service = Service(database: database, messageTypes: [MockMessage.self])
      let command = MockCommand()
      let response = try await service.perform(command: command) as? MockResponse

      XCTAssertEqual(response?.id, command.message.id)
      XCTAssertEqual(response?.items.count, command.message.count)
      XCTAssertEqual(database.didRequestCount, command.message.count)
    #else
      throw XCTSkip("SwiftData and XPC is not supported for test")
    #endif
  }
}
