//
//  HarvestResponseTests.swift
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

@Suite("Harvest Response Tests")
internal struct HarvestResponseTests {
  @Test("Initialization with default timestamp")
  internal func initializationWithDefaultTimestamp() {
    let requestId = UUID()
    let response = HarvestResponse(requestId: requestId, success: true)

    #expect(response.requestId == requestId)
    #expect(response.success)
    #expect(response.timestamp.timeIntervalSinceNow < 1.0)  // Created within the last second
    #expect(response.timestamp.timeIntervalSinceNow > -1.0)
  }

  @Test("Initialization with custom timestamp")
  internal func initializationWithCustomTimestamp() {
    let requestId = UUID()
    let customTimestamp = Date(timeIntervalSince1970: 1_640_995_200)  // 2022-01-01 00:00:00 UTC
    let response = HarvestResponse(requestId: requestId, timestamp: customTimestamp, success: false)

    #expect(response.requestId == requestId)
    #expect(!response.success)
    #expect(response.timestamp == customTimestamp)
  }

  @Test("Successful response creation")
  internal func successfulResponseCreation() {
    let requestId = UUID()
    let response = HarvestResponse(requestId: requestId, success: true)

    #expect(response.requestId == requestId)
    #expect(response.success)
  }

  @Test("Failed response creation")
  internal func failedResponseCreation() {
    let requestId = UUID()
    let response = HarvestResponse(requestId: requestId, success: false)

    #expect(response.requestId == requestId)
    #expect(!response.success)
  }

  @Test("Codable conformance")
  internal func codableConformance() throws {
    let requestId = UUID(uuidString: "E621E1F8-C36C-495A-93FC-0C247A3E6E5F")!
    let originalResponse = HarvestResponse(
      requestId: requestId,
      timestamp: Date(timeIntervalSince1970: 1_640_995_200),
      success: true
    )

    // Test encoding
    let encoder = JSONEncoder()
    encoder.dateEncodingStrategy = .iso8601
    let jsonData = try encoder.encode(originalResponse)

    // Verify JSON contains expected fields
    let jsonString = String(data: jsonData, encoding: .utf8)!
    #expect(jsonString.contains("E621E1F8-C36C-495A-93FC-0C247A3E6E5F"))
    #expect(jsonString.contains("true"))

    // Test decoding
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .iso8601
    let decodedResponse = try decoder.decode(HarvestResponse.self, from: jsonData)

    #expect(decodedResponse.requestId == originalResponse.requestId)
    #expect(decodedResponse.success == originalResponse.success)
    #expect(
      abs(
        decodedResponse.timestamp.timeIntervalSince1970
          - originalResponse.timestamp.timeIntervalSince1970) < 1.0)
  }

  @Test("Sendable conformance")
  internal func sendableConformance() async {
    let response = HarvestResponse(requestId: UUID(), success: true)

    // Transferring the value through a Task exercises Sendable across an actor
    // boundary; it fails to compile if conformance is missing.
    let received = await Task { response }.value
    #expect(received.requestId == response.requestId)
  }

  @Test("Request-response correlation")
  internal func requestResponseCorrelation() {
    let requestId = UUID()
    let request = HarvestRequest(id: requestId)
    let response = HarvestResponse(requestId: request.id, success: true)

    #expect(response.requestId == request.id)
  }

  @Test("JSON structure with success true")
  internal func jsonStructureWithSuccessTrue() throws {
    let requestId = UUID(uuidString: "123E4567-E89B-12D3-A456-426614174000")!
    let response = HarvestResponse(
      requestId: requestId,
      timestamp: Date(timeIntervalSince1970: 1_609_459_200),  // 2021-01-01 00:00:00 UTC
      success: true
    )

    let encoder = JSONEncoder()
    encoder.dateEncodingStrategy = .secondsSince1970
    encoder.outputFormatting = .prettyPrinted

    let jsonData = try encoder.encode(response)
    let jsonString = String(data: jsonData, encoding: .utf8)!

    // Verify JSON structure
    #expect(jsonString.contains("\"requestId\""))
    #expect(jsonString.contains("\"timestamp\""))
    #expect(jsonString.contains("\"success\""))
    #expect(jsonString.contains("123E4567-E89B-12D3-A456-426614174000"))
    #expect(jsonString.contains("1609459200"))
    #expect(jsonString.contains("true"))
  }

  @Test("JSON structure with success false")
  internal func jsonStructureWithSuccessFalse() throws {
    let requestId = UUID()
    let response = HarvestResponse(requestId: requestId, success: false)

    let encoder = JSONEncoder()
    encoder.outputFormatting = .prettyPrinted

    let jsonData = try encoder.encode(response)
    let jsonString = String(data: jsonData, encoding: .utf8)!

    #expect(jsonString.contains("\"success\" : false"))
  }

  @Test("Round-trip serialization preserves data")
  internal func roundTripSerializationPreservesData() throws {
    let responses = [
      HarvestResponse(requestId: UUID(), success: true),
      HarvestResponse(requestId: UUID(), success: false),
      HarvestResponse(requestId: UUID(), timestamp: Date.distantPast, success: true),
      HarvestResponse(requestId: UUID(), timestamp: Date.distantFuture, success: false),
    ]

    let encoder = JSONEncoder()
    encoder.dateEncodingStrategy = .millisecondsSince1970

    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .millisecondsSince1970

    for originalResponse in responses {
      let jsonData = try encoder.encode(originalResponse)
      let decodedResponse = try decoder.decode(HarvestResponse.self, from: jsonData)

      #expect(decodedResponse.requestId == originalResponse.requestId)
      #expect(decodedResponse.success == originalResponse.success)
      #expect(
        abs(
          decodedResponse.timestamp.timeIntervalSince1970
            - originalResponse.timestamp.timeIntervalSince1970) < 0.001)
    }
  }

  @Test("Response timing")
  internal func responseTiming() {
    let requestId = UUID()
    let startTime = Date()

    let response = HarvestResponse(requestId: requestId, success: true)

    let endTime = Date()

    #expect(response.timestamp >= startTime)
    #expect(response.timestamp <= endTime)
  }
}
