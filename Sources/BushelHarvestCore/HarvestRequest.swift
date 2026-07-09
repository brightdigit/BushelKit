//
//  HarvestRequest.swift
//  BushelKit
//
//  Created by Leo Dion.
//  Copyright © 2025 BrightDigit.
//
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the “Software”), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or
//  sell copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
//

public import Foundation

/// Request message structure for Harvest protocol communication
///
/// Represents a request sent from the Bushel host to a guest VM via the Harvest protocol.
/// Each request has a unique identifier for correlation with responses and a timestamp
/// for tracking and debugging purposes.
///
/// ## Usage
/// ```swift
/// // Create a request with auto-generated ID and current timestamp
/// let request = HarvestRequest()
///
/// // Create a request with custom values
/// let customRequest = HarvestRequest(
///   id: UUID(),
///   timestamp: Date()
/// )
/// ```
///
/// ## Protocol Flow
/// 1. Host creates a `HarvestRequest` with unique ID
/// 2. Request is sent to guest VM
/// 3. Guest processes request and returns `HarvestResponse` with matching `requestId`
public struct HarvestRequest: Codable, Sendable {
  /// Unique identifier for this request
  ///
  /// Used to correlate requests with their corresponding responses.
  /// Each request should have a unique ID to prevent response mixups
  /// in concurrent communication scenarios.
  public let id: UUID

  /// Timestamp when this request was created
  ///
  /// Useful for debugging, logging, and implementing request timeouts.
  /// Automatically set to the current time if not specified.
  public let timestamp: Date

  /// Creates a new Harvest request
  ///
  /// - Parameters:
  ///   - id: Unique identifier for the request. Defaults to a new UUID.
  ///   - timestamp: When the request was created. Defaults to current time.
  public init(id: UUID = UUID(), timestamp: Date = Date()) {
    self.id = id
    self.timestamp = timestamp
  }
}
