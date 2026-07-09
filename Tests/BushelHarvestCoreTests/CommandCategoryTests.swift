//
//  CommandCategoryTests.swift
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

@Suite("Command Category Tests")
internal struct CommandCategoryTests {
  @Test("Command category enum values")
  internal func commandCategoryEnumValues() {
    let allCategories: [CommandCategory] = [
      .system,
      .file,
      .network,
      .clipboard,
      .remote,
      .security,
    ]

    // Test that all categories have proper raw values
    #expect(CommandCategory.system.rawValue == "system")
    #expect(CommandCategory.file.rawValue == "file")
    #expect(CommandCategory.network.rawValue == "network")
    #expect(CommandCategory.clipboard.rawValue == "clipboard")
    #expect(CommandCategory.remote.rawValue == "remote")
    #expect(CommandCategory.security.rawValue == "security")

    // Test that categories can be created from raw values
    for category in allCategories {
      #expect(CommandCategory(rawValue: category.rawValue) == category)
    }
  }

  @Test("Command category Codable conformance")
  internal func commandCategoryCodableConformance() throws {
    let categories: [CommandCategory] = [
      .system, .file, .network, .clipboard, .remote, .security,
    ]

    let encoder = JSONEncoder()
    let decoder = JSONDecoder()

    for category in categories {
      let jsonData = try encoder.encode(category)
      let jsonString = try #require(String(data: jsonData, encoding: .utf8))

      // Verify the category is encoded as its raw value
      #expect(jsonString == "\"\(category.rawValue)\"")

      // Test decoding
      let decodedCategory = try decoder.decode(CommandCategory.self, from: jsonData)
      #expect(decodedCategory == category)
    }
  }

  @Test("Command category Sendable conformance")
  internal func commandCategorySendableConformance() async {
    let category = CommandCategory.system

    // Transferring the value into (and back out of) a Task exercises Sendable
    // across an actor boundary; it fails to compile if conformance is missing.
    let received = await Task { category }.value
    #expect(received == category)
  }

  @Test("Invalid command category from raw value")
  internal func invalidCommandCategoryFromRawValue() {
    #expect(CommandCategory(rawValue: "invalid") == nil)
    #expect(CommandCategory(rawValue: "") == nil)
    #expect(CommandCategory(rawValue: "SYSTEM") == nil)  // Case sensitive
  }

  @Test("Command category equality")
  internal func commandCategoryEquality() {
    let system1 = CommandCategory.system
    let system2 = CommandCategory.system
    #expect(system1 == system2)
    #expect(CommandCategory.system != CommandCategory.file)

    let category1 = CommandCategory.network
    let category2 = CommandCategory.network
    #expect(category1 == category2)
  }

  @Test("Command category Hashable")
  internal func commandCategoryHashable() {
    let categories: Set<CommandCategory> = [
      .system, .file, .network, .clipboard, .remote, .security,
    ]

    #expect(categories.count == 6)
    #expect(categories.contains(.system))
    #expect(categories.contains(.file))
    #expect(categories.contains(.network))
    #expect(categories.contains(.clipboard))
    #expect(categories.contains(.remote))
    #expect(categories.contains(.security))
  }
}
