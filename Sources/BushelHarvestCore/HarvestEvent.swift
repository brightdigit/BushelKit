//
//  HarvestEvent.swift
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

/// Event message structure for Harvest protocol communication
///
/// Represents an asynchronous event that can be sent between the Bushel host
/// and guest VM. Events are used for notifications, status updates, and other
/// non-request/response communication patterns.
///
/// ## Usage
/// ```swift
/// // Create a connection event
/// let connectionEvent = HarvestEvent(
///   eventType: "connection.established"
/// )
///
/// // Create a system event with custom ID and timestamp
/// let systemEvent = HarvestEvent(
///   id: UUID(),
///   timestamp: Date(),
///   eventType: "system.shutdown"
/// )
/// ```
///
/// ## Common Event Types
/// - `connection.established` - Connection between host and guest established
/// - `connection.lost` - Connection was lost
/// - `command.executed` - A command was executed successfully
/// - `file.transferred` - File transfer completed
/// - `system.error` - System-level error occurred
/// - `user.action` - User-initiated action
///
/// ## Event Flow
/// Unlike request/response pairs, events are fire-and-forget messages
/// that don't require acknowledgment or correlation with other messages.
public struct HarvestEvent: Codable, Sendable {
  /// Unique identifier for this event
  ///
  /// Each event gets a unique ID for tracking and deduplication purposes.
  /// Unlike requests, event IDs don't need to be correlated with responses.
  public let id: UUID

  /// Timestamp when this event was created
  ///
  /// Useful for event ordering, debugging, and audit trails.
  /// Automatically set to the current time if not specified.
  public let timestamp: Date

  /// Type identifier for this event
  ///
  /// A string identifier that describes the nature of the event.
  /// Should follow a consistent naming convention (e.g., "category.action").
  ///
  /// Examples:
  /// - `"connection.established"`
  /// - `"file.uploaded"`
  /// - `"system.error"`
  public let eventType: String

  /// Creates a new Harvest event
  ///
  /// - Parameters:
  ///   - id: Unique identifier for the event. Defaults to a new UUID.
  ///   - timestamp: When the event occurred. Defaults to current time.
  ///   - eventType: String identifier describing the event type
  public init(id: UUID = UUID(), timestamp: Date = Date(), eventType: String) {
    self.id = id
    self.timestamp = timestamp
    self.eventType = eventType
  }
}
