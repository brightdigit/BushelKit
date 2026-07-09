//
//  CommandProtocolTests.swift
//  BushelKit
//
//  Created by Leo Dion.
//  Copyright © 2024 BrightDigit.
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

import Foundation
import Testing

@testable import BushelHarvestCore

// Test implementation of HarvestCommandProtocol for testing purposes
private struct TestCommand: HarvestCommandProtocol {
  let id: UUID
  let category: CommandCategory
  let testData: String

  init(id: UUID = UUID(), category: CommandCategory, testData: String = "test") {
    self.id = id
    self.category = category
    self.testData = testData
  }
}

@Suite("Command Protocol Tests")
internal struct CommandProtocolTests {
  @Test("Protocol required properties")
  internal func protocolRequiredProperties() {
    let testId = UUID()
    let testCategory = CommandCategory.system
    let command = TestCommand(id: testId, category: testCategory)

    #expect(command.id == testId)
    #expect(command.category == testCategory)
  }

  @Test("Harvest command conforms to protocol")
  internal func harvestCommandConformsToProtocol() {
    let harvestCommand = HarvestCommand(category: .file)
    let protocolCommand: any HarvestCommandProtocol = harvestCommand

    #expect(protocolCommand.id == harvestCommand.id)
    #expect(protocolCommand.category == harvestCommand.category)
  }

  @Test("Protocol Codable conformance")
  internal func protocolCodableConformance() throws {
    let testCommand = try TestCommand(
      id: #require(UUID(uuidString: "E621E1F8-C36C-495A-93FC-0C247A3E6E5F")),
      category: .network,
      testData: "protocol test"
    )

    // Test encoding
    let encoder = JSONEncoder()
    let jsonData = try encoder.encode(testCommand)

    // Verify JSON contains expected fields
    let jsonString = try #require(String(data: jsonData, encoding: .utf8))
    #expect(jsonString.contains("E621E1F8-C36C-495A-93FC-0C247A3E6E5F"))
    #expect(jsonString.contains("network"))
    #expect(jsonString.contains("protocol test"))

    // Test decoding
    let decoder = JSONDecoder()
    let decodedCommand = try decoder.decode(TestCommand.self, from: jsonData)

    #expect(decodedCommand.id == testCommand.id)
    #expect(decodedCommand.category == testCommand.category)
    #expect(decodedCommand.testData == testCommand.testData)
  }

  @Test("Protocol Sendable conformance")
  internal func protocolSendableConformance() async {
    let command = TestCommand(category: .clipboard, testData: "sendable test")

    // Transferring the value through a Task exercises Sendable across an actor
    // boundary; it fails to compile if conformance is missing.
    let received = await Task { command }.value
    #expect(received.id == command.id)
    #expect(received.testData == command.testData)
  }

  @Test("Protocol polymorphism")
  internal func protocolPolymorphism() {
    let commands: [any HarvestCommandProtocol] = [
      HarvestCommand(category: .system),
      TestCommand(category: .file, testData: "polymorphism test"),
      HarvestCommand(category: .remote),
    ]

    // Test that we can work with different types through the protocol
    #expect(Set(commands.map(\.id)).count == commands.count)
    for command in commands {
      #expect([CommandCategory.system, .file, .remote].contains(command.category))
    }
  }

  @Test("Protocol as type erasure")
  internal func protocolAsTypeErasure() {
    func processCommand(_ command: any HarvestCommandProtocol) -> String {
      "Processing \(command.category.rawValue) command with ID \(command.id)"
    }

    let harvestCommand = HarvestCommand(category: .system)
    let testCommand = TestCommand(category: .file)

    let result1 = processCommand(harvestCommand)
    let result2 = processCommand(testCommand)

    #expect(result1.contains("system"))
    #expect(result1.contains(harvestCommand.id.uuidString))

    #expect(result2.contains("file"))
    #expect(result2.contains(testCommand.id.uuidString))
  }
}
