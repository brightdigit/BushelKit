//
//  HarvestResponse.swift
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

public import Foundation

/// Response message structure for Harvest protocol communication
///
/// Represents a response sent from a guest VM back to the Bushel host after
/// processing a request. Each response correlates to a specific request via
/// the `requestId` field and indicates success or failure of the operation.
///
/// ## Usage
/// ```swift
/// // Create a successful response
/// let successResponse = HarvestResponse(
///   requestId: request.id,
///   success: true
/// )
///
/// // Create a failed response with custom timestamp
/// let failureResponse = HarvestResponse(
///   requestId: request.id,
///   timestamp: Date(),
///   success: false
/// )
/// ```
///
/// ## Protocol Flow
/// 1. Guest VM receives a `HarvestRequest`
/// 2. Guest processes the request
/// 3. Guest creates `HarvestResponse` with matching `requestId`
/// 4. Response is sent back to host for correlation
public struct HarvestResponse: Codable, Sendable {
  /// Identifier of the request this response corresponds to
  ///
  /// Must match the `id` field from the original `HarvestRequest`
  /// to enable proper request-response correlation in the host.
  public let requestId: UUID

  /// Timestamp when this response was created
  ///
  /// Useful for measuring request processing time and debugging.
  /// Automatically set to the current time if not specified.
  public let timestamp: Date

  /// Indicates whether the request was processed successfully
  ///
  /// - `true`: Request was processed successfully
  /// - `false`: Request failed or encountered an error
  ///
  /// For more detailed error information, consider extending this
  /// structure with additional error fields in future iterations.
  public let success: Bool

  /// Creates a new Harvest response
  ///
  /// - Parameters:
  ///   - requestId: The ID of the request this response corresponds to
  ///   - timestamp: When the response was created. Defaults to current time.
  ///   - success: Whether the request processing was successful
  public init(requestId: UUID, timestamp: Date = Date(), success: Bool) {
    self.requestId = requestId
    self.timestamp = timestamp
    self.success = success
  }
}
