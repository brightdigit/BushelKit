//
//  HarvestCommandTests.swift
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

import Testing
@testable import BushelHarvestCore

@Suite("Harvest Command Tests")
internal struct HarvestCommandTests {
  @Test("Initialization with default ID")
  internal func initializationWithDefaultId() {
    let command = HarvestCommand(category: .system)
    
    #expect(command.id != nil)
    #expect(command.category == .system)
  }
  
  @Test("Initialization with custom ID")
  internal func initializationWithCustomId() {
    let customId = UUID(uuidString: "E621E1F8-C36C-495A-93FC-0C247A3E6E5F")!
    let command = HarvestCommand(id: customId, category: .file)
    
    #expect(command.id == customId)
    #expect(command.category == .file)
  }
  
  @Test("Unique ID generation")
  internal func uniqueIdGeneration() {
    let command1 = HarvestCommand(category: .system)
    let command2 = HarvestCommand(category: .system)
    
    #expect(command1.id != command2.id)
  }
  
  @Test("All command categories")
  internal func allCommandCategories() {
    let categories: [CommandCategory] = [.system, .file, .network, .clipboard, .remote]
    
    for category in categories {
      let command = HarvestCommand(category: category)
      #expect(command.category == category)
    }
  }
  
  @Test("Protocol conformance")
  internal func protocolConformance() {
    let command = HarvestCommand(category: .network)
    
    // Test that it conforms to HarvestCommandProtocol
    let protocolCommand: any HarvestCommandProtocol = command
    #expect(protocolCommand.id == command.id)
    #expect(protocolCommand.category == command.category)
  }
  
  @Test("Codable conformance")
  internal func codableConformance() throws {
    let originalCommand = HarvestCommand(
      id: UUID(uuidString: "E621E1F8-C36C-495A-93FC-0C247A3E6E5F")!,
      category: .clipboard
    )
    
    // Test encoding
    let encoder = JSONEncoder()
    let jsonData = try encoder.encode(originalCommand)
    
    // Verify JSON contains expected fields
    let jsonString = String(data: jsonData, encoding: .utf8)!
    #expect(jsonString.contains("E621E1F8-C36C-495A-93FC-0C247A3E6E5F"))
    #expect(jsonString.contains("clipboard"))
    
    // Test decoding
    let decoder = JSONDecoder()
    let decodedCommand = try decoder.decode(HarvestCommand.self, from: jsonData)
    
    #expect(decodedCommand.id == originalCommand.id)
    #expect(decodedCommand.category == originalCommand.category)
  }
  
  @Test("Sendable conformance")
  internal func sendableConformance() {
    let command = HarvestCommand(category: .remote)
    
    Task {
      await withCheckedContinuation { continuation in
        Task {
          // If HarvestCommand didn't conform to Sendable, this would cause a compiler error
          _ = command
          continuation.resume()
        }
      }
    }
  }
  
  @Test("JSON structure")
  internal func jsonStructure() throws {
    let command = HarvestCommand(
      id: UUID(uuidString: "123E4567-E89B-12D3-A456-426614174000")!,
      category: .system
    )
    
    let encoder = JSONEncoder()
    encoder.outputFormatting = .prettyPrinted
    
    let jsonData = try encoder.encode(command)
    let jsonString = String(data: jsonData, encoding: .utf8)!
    
    // Verify JSON structure
    #expect(jsonString.contains("\"id\""))
    #expect(jsonString.contains("\"category\""))
    #expect(jsonString.contains("123E4567-E89B-12D3-A456-426614174000"))
    #expect(jsonString.contains("system"))
  }
  
  @Test("Round-trip serialization preserves data")
  internal func roundTripSerializationPreservesData() throws {
    let commands = [
      HarvestCommand(category: .system),
      HarvestCommand(category: .file),
      HarvestCommand(category: .network),
      HarvestCommand(category: .clipboard),
      HarvestCommand(category: .remote)
    ]
    
    let encoder = JSONEncoder()
    let decoder = JSONDecoder()
    
    for originalCommand in commands {
      let jsonData = try encoder.encode(originalCommand)
      let decodedCommand = try decoder.decode(HarvestCommand.self, from: jsonData)
      
      #expect(decodedCommand.id == originalCommand.id)
      #expect(decodedCommand.category == originalCommand.category)
    }
  }
  
  @Test("Command category raw values")
  internal func commandCategoryRawValues() {
    #expect(CommandCategory.system.rawValue == "system")
    #expect(CommandCategory.file.rawValue == "file")
    #expect(CommandCategory.network.rawValue == "network")
    #expect(CommandCategory.clipboard.rawValue == "clipboard")
    #expect(CommandCategory.remote.rawValue == "remote")
  }
  
  @Test("Command category from raw value")
  internal func commandCategoryFromRawValue() {
    #expect(CommandCategory(rawValue: "system") == .system)
    #expect(CommandCategory(rawValue: "file") == .file)
    #expect(CommandCategory(rawValue: "network") == .network)
    #expect(CommandCategory(rawValue: "clipboard") == .clipboard)
    #expect(CommandCategory(rawValue: "remote") == .remote)
    #expect(CommandCategory(rawValue: "unknown") == nil)
  }
  
  @Test("Command category Codable")
  internal func commandCategoryCodable() throws {
    let categories: [CommandCategory] = [.system, .file, .network, .clipboard, .remote]
    
    let encoder = JSONEncoder()
    let decoder = JSONDecoder()
    
    for category in categories {
      let jsonData = try encoder.encode(category)
      let decodedCategory = try decoder.decode(CommandCategory.self, from: jsonData)
      #expect(decodedCategory == category)
    }
  }
  
  @Test("Command creation consistency")
  internal func commandCreationConsistency() {
    let category = CommandCategory.file
    let command1 = HarvestCommand(category: category)
    let command2 = HarvestCommand(category: category)
    
    // Different IDs but same category
    #expect(command1.id != command2.id)
    #expect(command1.category == command2.category)
  }
}