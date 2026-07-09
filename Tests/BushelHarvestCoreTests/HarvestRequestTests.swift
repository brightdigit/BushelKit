//
//  HarvestRequestTests.swift
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

@Suite("Harvest Request Tests")
internal struct HarvestRequestTests {
  @Test("Default initialization")
  internal func defaultInitialization() {
    let request = HarvestRequest()

    #expect(request.timestamp.timeIntervalSinceNow < 1.0)  // Created within the last second
    #expect(request.timestamp.timeIntervalSinceNow > -1.0)
  }

  @Test("Custom initialization")
  internal func customInitialization() {
    let customId = UUID()
    let customTimestamp = Date(timeIntervalSince1970: 1_640_995_200)  // 2022-01-01 00:00:00 UTC

    let request = HarvestRequest(id: customId, timestamp: customTimestamp)

    #expect(request.id == customId)
    #expect(request.timestamp == customTimestamp)
  }

  @Test("Codable conformance")
  internal func codableConformance() throws {
    let originalRequest = HarvestRequest(
      id: UUID(uuidString: "E621E1F8-C36C-495A-93FC-0C247A3E6E5F")!,
      timestamp: Date(timeIntervalSince1970: 1_640_995_200)
    )

    // Test encoding
    let encoder = JSONEncoder()
    encoder.dateEncodingStrategy = .iso8601
    let jsonData = try encoder.encode(originalRequest)

    // Verify JSON contains expected fields
    let jsonString = String(data: jsonData, encoding: .utf8)!
    #expect(jsonString.contains("E621E1F8-C36C-495A-93FC-0C247A3E6E5F"))

    // Test decoding
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .iso8601
    let decodedRequest = try decoder.decode(HarvestRequest.self, from: jsonData)

    #expect(decodedRequest.id == originalRequest.id)
    #expect(
      abs(
        decodedRequest.timestamp.timeIntervalSince1970
          - originalRequest.timestamp.timeIntervalSince1970) < 1.0)
  }

  @Test("Sendable conformance")
  internal func sendableConformance() async {
    let request = HarvestRequest()

    // Transferring the value through a Task exercises Sendable across an actor
    // boundary; it fails to compile if conformance is missing.
    let received = await Task { request }.value
    #expect(received.id == request.id)
  }

  @Test("Unique IDs generated")
  internal func uniqueIdsGenerated() {
    let request1 = HarvestRequest()
    let request2 = HarvestRequest()

    #expect(request1.id != request2.id)
  }

  @Test("Timestamp ordering")
  internal func timestampOrdering() {
    let request1 = HarvestRequest()

    // Small delay to ensure different timestamps
    Thread.sleep(forTimeInterval: 0.01)

    let request2 = HarvestRequest()

    #expect(request1.timestamp < request2.timestamp)
  }

  @Test("JSON structure")
  internal func jsonStructure() throws {
    let request = HarvestRequest(
      id: UUID(uuidString: "123E4567-E89B-12D3-A456-426614174000")!,
      timestamp: Date(timeIntervalSince1970: 1_609_459_200)  // 2021-01-01 00:00:00 UTC
    )

    let encoder = JSONEncoder()
    encoder.dateEncodingStrategy = .secondsSince1970
    encoder.outputFormatting = .prettyPrinted

    let jsonData = try encoder.encode(request)
    let jsonString = String(data: jsonData, encoding: .utf8)!

    // Verify JSON structure
    #expect(jsonString.contains("\"id\""))
    #expect(jsonString.contains("\"timestamp\""))
    #expect(jsonString.contains("123E4567-E89B-12D3-A456-426614174000"))
    #expect(jsonString.contains("1609459200"))
  }

  @Test("Round-trip serialization preserves data")
  internal func roundTripSerializationPreservesData() throws {
    let requests = [
      HarvestRequest(),
      HarvestRequest(id: UUID(), timestamp: Date.distantPast),
      HarvestRequest(id: UUID(), timestamp: Date.distantFuture),
    ]

    let encoder = JSONEncoder()
    encoder.dateEncodingStrategy = .millisecondsSince1970

    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .millisecondsSince1970

    for originalRequest in requests {
      let jsonData = try encoder.encode(originalRequest)
      let decodedRequest = try decoder.decode(HarvestRequest.self, from: jsonData)

      #expect(decodedRequest.id == originalRequest.id)
      #expect(
        abs(
          decodedRequest.timestamp.timeIntervalSince1970
            - originalRequest.timestamp.timeIntervalSince1970) < 0.001)
    }
  }
}
