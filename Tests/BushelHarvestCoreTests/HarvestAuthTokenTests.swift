//
//  HarvestAuthTokenTests.swift
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

@Suite("Harvest Auth Token Tests")
internal struct HarvestAuthTokenTests {
  @Test("Token initialization")
  internal func tokenInitialization() {
    let token = "test-token-123"
    let expirationDate = Date().addingTimeInterval(3600)  // 1 hour from now

    let authToken = HarvestAuthToken(token: token, expiresAt: expirationDate)

    #expect(authToken.token == token)
    #expect(authToken.expiresAt == expirationDate)
  }

  @Test("Codable conformance")
  internal func codableConformance() throws {
    let originalToken = HarvestAuthToken(
      token: "sample-auth-token",
      expiresAt: Date(timeIntervalSince1970: 1_640_995_200)  // 2022-01-01 00:00:00 UTC
    )

    // Test encoding
    let encoder = JSONEncoder()
    encoder.dateEncodingStrategy = .secondsSince1970
    let jsonData = try encoder.encode(originalToken)

    // Test decoding
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .secondsSince1970
    let decodedToken = try decoder.decode(HarvestAuthToken.self, from: jsonData)

    #expect(decodedToken.token == originalToken.token)
    #expect(
      abs(
        decodedToken.expiresAt.timeIntervalSince1970 - originalToken.expiresAt.timeIntervalSince1970
      ) < 1.0)
  }

  @Test("Sendable conformance")
  internal func sendableConformance() async {
    let token = HarvestAuthToken(token: "test", expiresAt: Date())

    // Transferring the value through a Task exercises Sendable across an actor
    // boundary; it fails to compile if conformance is missing.
    let received = await Task { token }.value
    #expect(received.token == token.token)
  }

  @Test("Token expiration validation")
  internal func tokenExpirationValidation() {
    let pastDate = Date().addingTimeInterval(-3600)  // 1 hour ago
    let futureDate = Date().addingTimeInterval(3600)  // 1 hour from now

    let expiredToken = HarvestAuthToken(token: "expired", expiresAt: pastDate)
    let validToken = HarvestAuthToken(token: "valid", expiresAt: futureDate)

    #expect(expiredToken.isExpired())
    #expect(!validToken.isExpired())
  }

  @Test("isExpired compares against the provided reference date")
  internal func isExpiredWithReferenceDate() {
    let expiry = Date(timeIntervalSince1970: 1_000_000)
    let token = HarvestAuthToken(token: "ref", expiresAt: expiry)

    #expect(token.isExpired(asOf: expiry.addingTimeInterval(1)))
    #expect(token.isExpired(asOf: expiry))  // Expiry boundary counts as expired.
    #expect(!token.isExpired(asOf: expiry.addingTimeInterval(-1)))
  }

  @Test("JSON serialization")
  internal func jsonSerialization() throws {
    let token = HarvestAuthToken(
      token: "jwt.token.here",
      expiresAt: Date(timeIntervalSince1970: 1_700_000_000)
    )

    let encoder = JSONEncoder()
    encoder.dateEncodingStrategy = .iso8601
    let jsonData = try encoder.encode(token)

    let jsonString = String(data: jsonData, encoding: .utf8)
    #expect(jsonString != nil)
    #expect(jsonString!.contains("jwt.token.here"))

    // Verify round-trip
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .iso8601
    let decodedToken = try decoder.decode(HarvestAuthToken.self, from: jsonData)

    #expect(decodedToken.token == token.token)
    #expect(
      abs(decodedToken.expiresAt.timeIntervalSince1970 - token.expiresAt.timeIntervalSince1970)
        < 1.0)
  }
}
