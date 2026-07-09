//
//  HarvestEventTests.swift
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

@Suite("Harvest Event Tests")
internal struct HarvestEventTests {
  @Test("Initialization with default values")
  internal func initializationWithDefaultValues() {
    let eventType = "connection.established"
    let event = HarvestEvent(eventType: eventType)

    #expect(event.eventType == eventType)
    #expect(event.timestamp.timeIntervalSinceNow < 1.0)  // Created within the last second
    #expect(event.timestamp.timeIntervalSinceNow > -1.0)
  }

  @Test("Initialization with custom values")
  internal func initializationWithCustomValues() throws {
    let customId = try #require(UUID(uuidString: "E621E1F8-C36C-495A-93FC-0C247A3E6E5F"))
    let customTimestamp = Date(timeIntervalSince1970: 1_640_995_200)  // 2022-01-01 00:00:00 UTC
    let eventType = "system.shutdown"

    let event = HarvestEvent(id: customId, timestamp: customTimestamp, eventType: eventType)

    #expect(event.id == customId)
    #expect(event.timestamp == customTimestamp)
    #expect(event.eventType == eventType)
  }

  @Test("Unique ID generation")
  internal func uniqueIdGeneration() {
    let event1 = HarvestEvent(eventType: "test.event")
    let event2 = HarvestEvent(eventType: "test.event")

    #expect(event1.id != event2.id)
  }

  @Test("Event type handling")
  internal func eventTypeHandling() {
    let eventTypes = [
      "connection.established",
      "connection.lost",
      "command.executed",
      "file.transferred",
      "system.error",
      "user.action",
    ]

    for eventType in eventTypes {
      let event = HarvestEvent(eventType: eventType)
      #expect(event.eventType == eventType)
    }
  }

  @Test("Codable conformance")
  internal func codableConformance() throws {
    let originalEvent = try HarvestEvent(
      id: #require(UUID(uuidString: "E621E1F8-C36C-495A-93FC-0C247A3E6E5F")),
      timestamp: Date(timeIntervalSince1970: 1_640_995_200),
      eventType: "test.codable.event"
    )

    // Test encoding
    let encoder = JSONEncoder()
    encoder.dateEncodingStrategy = .iso8601
    let jsonData = try encoder.encode(originalEvent)

    // Verify JSON contains expected fields
    let jsonString = try #require(String(data: jsonData, encoding: .utf8))
    #expect(jsonString.contains("E621E1F8-C36C-495A-93FC-0C247A3E6E5F"))
    #expect(jsonString.contains("test.codable.event"))

    // Test decoding
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .iso8601
    let decodedEvent = try decoder.decode(HarvestEvent.self, from: jsonData)

    #expect(decodedEvent.id == originalEvent.id)
    #expect(decodedEvent.eventType == originalEvent.eventType)
    #expect(
      abs(
        decodedEvent.timestamp.timeIntervalSince1970 - originalEvent.timestamp.timeIntervalSince1970
      ) < 1.0)
  }

  @Test("Sendable conformance")
  internal func sendableConformance() async {
    let event = HarvestEvent(eventType: "sendable.test")

    // Transferring the value through a Task exercises Sendable across an actor
    // boundary; it fails to compile if conformance is missing.
    let received = await Task { event }.value
    #expect(received.id == event.id)
  }

  @Test("JSON structure")
  internal func jsonStructure() throws {
    let event = try HarvestEvent(
      id: #require(UUID(uuidString: "123E4567-E89B-12D3-A456-426614174000")),
      timestamp: Date(timeIntervalSince1970: 1_609_459_200),  // 2021-01-01 00:00:00 UTC
      eventType: "json.structure.test"
    )

    let encoder = JSONEncoder()
    encoder.dateEncodingStrategy = .secondsSince1970
    encoder.outputFormatting = .prettyPrinted

    let jsonData = try encoder.encode(event)
    let jsonString = try #require(String(data: jsonData, encoding: .utf8))

    // Verify JSON structure
    #expect(jsonString.contains("\"id\""))
    #expect(jsonString.contains("\"timestamp\""))
    #expect(jsonString.contains("\"eventType\""))
    #expect(jsonString.contains("123E4567-E89B-12D3-A456-426614174000"))
    #expect(jsonString.contains("1609459200"))
    #expect(jsonString.contains("json.structure.test"))
  }

  @Test("Event sequencing")
  internal func eventSequencing() {
    let event1 = HarvestEvent(eventType: "first.event")

    // Small delay to ensure different timestamps
    Thread.sleep(forTimeInterval: 0.01)

    let event2 = HarvestEvent(eventType: "second.event")

    #expect(event1.timestamp < event2.timestamp)
  }

  @Test("Round-trip serialization preserves data")
  internal func roundTripSerializationPreservesData() throws {
    let events = [
      HarvestEvent(eventType: "simple.event"),
      HarvestEvent(id: UUID(), timestamp: Date.distantPast, eventType: "past.event"),
      HarvestEvent(id: UUID(), timestamp: Date.distantFuture, eventType: "future.event"),
      HarvestEvent(eventType: "special.chars.event!@#$%^&*()_+"),
    ]

    let encoder = JSONEncoder()
    encoder.dateEncodingStrategy = .millisecondsSince1970

    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .millisecondsSince1970

    for originalEvent in events {
      let jsonData = try encoder.encode(originalEvent)
      let decodedEvent = try decoder.decode(HarvestEvent.self, from: jsonData)

      #expect(decodedEvent.id == originalEvent.id)
      #expect(decodedEvent.eventType == originalEvent.eventType)
      let timestampDelta = abs(
        decodedEvent.timestamp.timeIntervalSince1970
          - originalEvent.timestamp.timeIntervalSince1970
      )
      #expect(timestampDelta < 0.001)
    }
  }

  @Test("Empty event type")
  internal func emptyEventType() {
    let event = HarvestEvent(eventType: "")
    #expect(event.eventType.isEmpty)
  }

  @Test("Long event type")
  internal func longEventType() {
    let longEventType = String(repeating: "very.long.event.type.", count: 100)
    let event = HarvestEvent(eventType: longEventType)
    #expect(event.eventType == longEventType)
  }
}
